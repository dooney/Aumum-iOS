//
//  VerifyScene.m
//  iosapp
//
//  Created by Simpson Du on 24/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "VerifyScene.h"
#import "PrimaryButton.h"
#import "JVFloatLabeledTextField.h"
#import "UIViewController+MBHud.h"
#import "UIView+FLKAutoLayout.h"
#import "VerifySceneModel.h"
#import "MZTimerLabel.h"
#import <SMS_SDK/SMS_SDK.h>
#import "URLManager.h"
#import "EaseMob.h"
#import "KeyChainUtil.h"

@interface VerifyScene()<UITextFieldDelegate, MZTimerLabelDelegate>

@property (nonatomic, strong)UIView* mainLayout;
@property (nonatomic, strong)JVFloatLabeledTextField* codeText;
@property (nonatomic, strong)UIButton* verifyButton;
@property (nonatomic, strong)UIView* resendLayout;
@property (nonatomic, strong)UILabel* countDown;
@property (nonatomic, strong)UIButton* resendButton;
@property (nonatomic, strong)MZTimerLabel* timer;
@property (nonatomic, strong)VerifySceneModel* sceneModel;

@end

@implementation VerifyScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addControls];
    [self loadAutoLayout];
    [self initSceneModel];
    [self bindToSceneModel];
}

- (void)initView {
    self.view.backgroundColor = HEX_RGB(0xff6060);
}

- (void)addControls {
    self.mainLayout = [[UIView alloc] init];
    [self.view addSubview:self.mainLayout];
    
    self.codeText = [[JVFloatLabeledTextField alloc] init];
    self.codeText.keyboardType = UIKeyboardTypePhonePad;
    [self.codeText setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"label.code", nil) attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]];
    self.codeText.delegate = self;
    [self.codeText becomeFirstResponder];
    [self.mainLayout addSubview:self.codeText];
    
    self.verifyButton = [[PrimaryButton alloc] initWithTitle:NSLocalizedString(@"label.submit", nil)];
    [self.verifyButton addTarget:self action:@selector(verifyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.mainLayout addSubview:self.verifyButton];
    
    self.resendLayout = [[UIView alloc] init];
    [self.mainLayout addSubview:self.resendLayout];
    
    self.countDown = [[UILabel alloc] init];
    self.countDown.font = [UIFont systemFontOfSize:14];
    self.countDown.textColor = [UIColor whiteColor];
    [self.resendLayout addSubview:self.countDown];
    
    self.resendButton = [[PrimaryButton alloc] initWithTitle:NSLocalizedString(@"label.resend", nil)];
    [self.resendButton addTarget:self action:@selector(resendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.resendLayout addSubview:self.resendButton];
    
    self.timer = [[MZTimerLabel alloc] initWithLabel:self.countDown andTimerType:MZTimerLabelTypeTimer];
    [self.timer setCountDownTime:60];
    self.timer.delegate = self;
    [self.timer start];
    
    [self loadHud:self.view];
}

- (void)loadAutoLayout {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    [self.mainLayout alignCenterWithView:self.mainLayout.superview];
    [self.mainLayout constrainWidth:[NSString stringWithFormat:@"%f", width * 0.8] height:@"200"];
    [self.codeText alignTop:@"0" leading:@"0" toView:self.codeText.superview];
    [self.codeText constrainWidth:[NSString stringWithFormat:@"%f", width * 0.8]];
    [self.countDown alignCenterWithView:self.countDown.superview];
    [self.resendButton alignToView:self.resendButton.superview];
    NSArray* layouts = @[self.codeText, self.verifyButton, self.resendLayout];
    [UIView spaceOutViewsVertically:layouts predicate:@"20"];
    [UIView alignLeadingEdgesOfViews:layouts];
    [UIView alignTrailingEdgesOfViews:layouts];
}

- (void)initSceneModel {
    self.sceneModel = [VerifySceneModel SceneModel];
    self.sceneModel.username = self.params[@"username"];
    self.sceneModel.zone = self.params[@"zone"];
    self.sceneModel.password = self.params[@"password"];
    
    [self.sceneModel.request onRequest:^{
        [KeyChainUtil setToken:self.sceneModel.request.profile.sessionToken];
        [KeyChainUtil setCurrentUserId:self.sceneModel.request.profile.objectId];
        NSString* chatId = [self.sceneModel.request.profile.objectId lowercaseString];
        //[[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:chatId password:self.sceneModel.password];
        NSString* url = [NSString stringWithFormat:@"iosapp://avatar?userId=%@", self.sceneModel.request.profile.objectId];
        [URLManager pushURLString:url animated:YES];
        [self hideHud];
    } error:^(NSError *error) {
        [self hideHudFailed:error.localizedDescription];
    }];
}

- (void)bindToSceneModel {
    RAC(self.sceneModel, code) = self.codeText.rac_textSignal;
    @weakify(self)
    [[RACObserve(self.sceneModel, code) filter:^BOOL(id value) {
        @strongify(self)
        return [self.sceneModel isValid];
    }] subscribeNext:^(NSNumber* verifyButtonEnabled) {
        @strongify(self)
        [self.verifyButton setEnabled:[verifyButtonEnabled boolValue]];
    }];
    [RACObserve(self.sceneModel, enableResend) subscribeNext:^(id value) {
        @strongify(self)
        self.countDown.hidden = [value boolValue];
        self.resendButton.hidden = ![value boolValue];
    }];
}

- (void)verifyButtonPressed {
    [self showHudIndeterminate:NSLocalizedString(@"info.submitting", nil)];
    [SMS_SDK commitVerifyCode:self.sceneModel.code result:^(enum SMS_ResponseState state) {
        if (state == SMS_ResponseStateFail) {
            [self hideHudFailed:NSLocalizedString(@"error.verifyCode", nil)];
        } else {
            NSString* username = [self.sceneModel.zone stringByAppendingFormat:@"%lld", [self.sceneModel.username longLongValue]];
            [self.sceneModel.request doRegister:username password:self.sceneModel.password];
        }
    }];
}

- (void)resendButtonPressed {
    [self showHudIndeterminate:NSLocalizedString(@"info.sending", nil)];
    [SMS_SDK getVerificationCodeBySMSWithPhone:self.sceneModel.username
                                          zone:[self.sceneModel.zone stringByReplacingOccurrencesOfString:@"+" withString:@""]
                                        result:^(SMS_SDKError *error) {
                                            if (error) {
                                                [self hideHudFailed:error.errorDescription];
                                            } else {
                                                [self hideHud];
                                                [self.timer reset];
                                                [self.timer start];
                                                self.sceneModel.enableResend = NO;
                                                self.codeText.text = @"";
                                                [self.codeText becomeFirstResponder];
                                            }
                                        }];
}

- (NSString*)timerLabel:(MZTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time {
    int seconds = (int)time % 60;
    return [NSString stringWithFormat:NSLocalizedString(@"label.shouldReceiveCodeWithinSeconds", nil), seconds];
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    self.sceneModel.enableResend = YES;
}

@end
