//
//  SignUpScene.m
//  iosapp
//
//  Created by Simpson Du on 22/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "SignUpScene.h"
#import "PrimaryButton.h"
#import "JVFloatLabeledTextField.h"
#import "UIView+FLKAutoLayout.h"
#import "SignUpSceneModel.h"
#import "UIViewController+MBHud.h"
#import "CountryScene.h"
#import "UIAlertView+Blocks.h"
#import <SMS_SDK/SMS_SDK.h>
#import <URLManager.h>

@interface SignUpScene()<UITextFieldDelegate, CountryDelegate>

@property (nonatomic, strong)UIView* mainLayout;
@property (nonatomic, strong)UIView* inputLayout;
@property (nonatomic, strong)UIView* separateLine;
@property (nonatomic, strong)UIView* usernameLayout;
@property (nonatomic, strong)UIButton* zoneButton;
@property (nonatomic, strong)JVFloatLabeledTextField* usernameText;
@property (nonatomic, strong)JVFloatLabeledTextField* passwordText;
@property (nonatomic, strong)UIButton* signUpButton;

@property (nonatomic, strong)SignUpSceneModel* sceneModel;

@end

@implementation SignUpScene

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
    
    self.inputLayout = [[UIView alloc] init];
    self.inputLayout.backgroundColor = HEX_RGB(0xff7777);
    self.inputLayout.layer.cornerRadius = 5;
    [self.mainLayout addSubview:self.inputLayout];
    
    self.separateLine = [[UIView alloc] init];
    self.separateLine.backgroundColor = HEX_RGBA(0x000000, 0.1);
    [self.inputLayout addSubview:self.separateLine];
    
    self.usernameLayout = [[UIView alloc] init];
    [self.inputLayout addSubview:self.usernameLayout];
    
    self.zoneButton = [[UIButton alloc] init];
    self.zoneButton.layer.cornerRadius = 5;
    self.zoneButton.backgroundColor = HEX_RGB(0xffde00);
    self.zoneButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.zoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.zoneButton addTarget:self action:@selector(codeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.usernameLayout addSubview:self.zoneButton];
    
    self.usernameText = [[JVFloatLabeledTextField alloc] init];
    self.usernameText.keyboardType = UIKeyboardTypePhonePad;
    [self.usernameText setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"label.userName", nil) attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]];
    self.usernameText.delegate = self;
    [self.usernameLayout addSubview:self.usernameText];
    
    self.passwordText = [[JVFloatLabeledTextField alloc] init];
    self.passwordText.secureTextEntry = YES;
    [self.passwordText setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"label.password", nil) attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]];
    self.passwordText.delegate = self;
    [self.inputLayout addSubview:self.passwordText];
    
    self.signUpButton = [[PrimaryButton alloc] initWithTitle:NSLocalizedString(@"label.signUp", nil)];
    [self.signUpButton addTarget:self action:@selector(signUpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.mainLayout addSubview:self.signUpButton];
    
    [self loadHud:self.view];
}

- (void)loadAutoLayout {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    NSString* mainLayoutWidth = [NSString stringWithFormat:@"%f", width * 0.8];
    [self.mainLayout alignCenterWithView:self.mainLayout.superview];
    [self.mainLayout constrainWidth:mainLayoutWidth height:@"200"];
    
    [self.separateLine alignCenterWithView:self.separateLine.superview];
    [self.separateLine constrainWidth:mainLayoutWidth height:@"0.5"];
    
    [self.zoneButton alignTop:nil leading:nil toView:self.zoneButton.superview];
    [self.zoneButton constrainWidth:@"44" height:@"32"];
    [self.usernameText constrainWidth:[NSString stringWithFormat:@"%f", width * 0.8 - 64]];
    NSArray* userNamelayouts = @[self.zoneButton, self.usernameText];
    [UIView spaceOutViewsHorizontally:userNamelayouts predicate:@"10"];
    [UIView alignTopEdgesOfViews:userNamelayouts];
    
    [self.usernameLayout alignTop:@"10" leading:@"10" bottom:nil trailing:@"-10" toView:self.usernameLayout.superview];
    [self.usernameLayout constrainHeight:@"40"];
    NSArray* inputlayouts = @[self.usernameLayout, self.passwordText];
    [UIView spaceOutViewsVertically:inputlayouts predicate:@"10"];
    [UIView alignLeadingEdgesOfViews:inputlayouts];
    [UIView alignTrailingEdgesOfViews:inputlayouts];
    
    [self.inputLayout alignTop:nil leading:nil toView:self.inputLayout.superview];
    [self.inputLayout constrainWidth:mainLayoutWidth height:@"100"];
    NSArray* mainLayouts = @[self.inputLayout, self.signUpButton];
    [UIView spaceOutViewsVertically:mainLayouts predicate:@"20"];
    [UIView alignLeadingEdgesOfViews:mainLayouts];
    [UIView alignTrailingEdgesOfViews:mainLayouts];
}

- (void)initSceneModel {
    self.sceneModel = [SignUpSceneModel SceneModel];
    self.sceneModel.zone = @"+61";
}

- (void)bindToSceneModel {
    [self.zoneButton rac_liftSelector:@selector(setTitle:forState:) withSignals:RACObserve(self.sceneModel, zone), [RACSignal return:@(UIControlStateNormal)], nil];
    RAC(self.sceneModel, username) = self.usernameText.rac_textSignal;
    RAC(self.sceneModel, password) = self.passwordText.rac_textSignal;
    @weakify(self)
    [[[RACSignal combineLatest:@[RACObserve(self.sceneModel, username), RACObserve(self.sceneModel, password)]] reduceEach:^id(NSString* username, NSString* password){
        @strongify(self)
        return @([self.sceneModel isValid]);
    }] subscribeNext:^(NSNumber* loginButtonEnabled) {
        @strongify(self)
        [self.signUpButton setEnabled:[loginButtonEnabled boolValue]];
    }];
}

- (void)codeButtonPressed {
    CountryScene* countryScene = [[CountryScene alloc] init];
    countryScene.delegate = self;
    [self.navigationController pushViewController:countryScene animated:YES];
}

- (void)signUpButtonPressed {
    NSString* mobileNumber = [self.sceneModel.zone stringByAppendingFormat:@"%lld", [self.sceneModel.username longLongValue]];
    [UIAlertView showWithTitle:mobileNumber
                       message:NSLocalizedString(@"label.willSendCode", nil)
             cancelButtonTitle:NSLocalizedString(@"label.cancel", nil)
             otherButtonTitles:@[NSLocalizedString(@"label.confirm", nil)]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == 1) {
                              [self showHudIndeterminate:NSLocalizedString(@"info.sending", nil)];
                              [SMS_SDK getVerificationCodeBySMSWithPhone:self.sceneModel.username
                                                                    zone:[self.sceneModel.zone stringByReplacingOccurrencesOfString:@"+" withString:@""]
                                                                  result:^(SMS_SDKError *error) {
                                                                      if (error) {
                                                                          [self hideHudFailed:error.errorDescription];
                                                                      } else {
                                                                          [self hideHud];
                                                                          NSString* url = [NSString stringWithFormat:@"iosapp://verify?username=%@&zone=%@", self.sceneModel.username, self.sceneModel.zone];
                                                                          [URLManager pushURLString:url animated:YES];
                                                                      }
                                                                  }];
                          }
    }];
}

- (void)getCountry:(Country *)country {
    self.sceneModel.zone = country.code;
}

@end
