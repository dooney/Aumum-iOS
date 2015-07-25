//
//  SignInScene.m
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "SignInScene.h"
#import "PrimaryButton.h"
#import "JVFloatLabeledTextField.h"
#import "UIView+FLKAutoLayout.h"
#import "SignInSceneModel.h"
#import "UIViewController+MBHud.h"
#import "KeyChainUtil.h"
#import "EaseMob.h"
#import "URLManager.h"
#import "CountryScene.h"

@interface SignInScene()<UITextFieldDelegate, CountryDelegate>

@property (nonatomic, strong)UIView* mainLayout;
@property (nonatomic, strong)UIView* inputLayout;
@property (nonatomic, strong)UIView* separateLine;
@property (nonatomic, strong)UIView* usernameLayout;
@property (nonatomic, strong)UIButton* codeButton;
@property (nonatomic, strong)JVFloatLabeledTextField* usernameText;
@property (nonatomic, strong)JVFloatLabeledTextField* passwordText;
@property (nonatomic, strong)UIView* buttonLayout;
@property (nonatomic, strong)UIView* logInLayout;
@property (nonatomic, strong)UIView* signUpLayout;
@property (nonatomic, strong)UIButton* logInButton;
@property (nonatomic, strong)UIButton* signUpButton;

@property (nonatomic, strong)SignInSceneModel* sceneModel;

@end

@implementation SignInScene

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
    
    self.codeButton = [[UIButton alloc] init];
    self.codeButton.layer.cornerRadius = 5;
    self.codeButton.backgroundColor = HEX_RGB(0xffde00);
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(codeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.usernameLayout addSubview:self.codeButton];
    
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
    
    self.buttonLayout = [[UIView alloc] init];
    [self.mainLayout addSubview:self.buttonLayout];
    
    self.logInLayout = [[UIView alloc] init];
    [self.buttonLayout addSubview:self.logInLayout];
    
    self.signUpLayout = [[UIView alloc] init];
    [self.buttonLayout addSubview:self.signUpLayout];
    
    self.logInButton = [[PrimaryButton alloc] initWithTitle:NSLocalizedString(@"label.logIn", nil)];
    [self.logInButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.logInLayout addSubview:self.logInButton];
    
    self.signUpButton = [[UIButton alloc] init];
    [self.signUpButton setTitle:NSLocalizedString(@"label.signUp", nil) forState:UIControlStateNormal];
    [self.signUpButton addTarget:self action:@selector(signUpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.signUpLayout addSubview:self.signUpButton];
    
    [self loadHud:self.view];
}

- (void)loadAutoLayout {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    NSString* mainLayoutWidth = [NSString stringWithFormat:@"%f", width * 0.8];
    [self.mainLayout alignCenterWithView:self.mainLayout.superview];
    [self.mainLayout constrainWidth:mainLayoutWidth height:@"200"];
    
    [self.separateLine alignCenterWithView:self.separateLine.superview];
    [self.separateLine constrainWidth:mainLayoutWidth height:@"0.5"];
    
    [self.codeButton alignTop:nil leading:nil toView:self.codeButton.superview];
    [self.codeButton constrainWidth:@"44" height:@"32"];
    [self.usernameText constrainWidth:[NSString stringWithFormat:@"%f", width * 0.8 - 64]];
    NSArray* userNamelayouts = @[self.codeButton, self.usernameText];
    [UIView spaceOutViewsHorizontally:userNamelayouts predicate:@"10"];
    [UIView alignTopEdgesOfViews:userNamelayouts];
    
    [self.usernameLayout alignTop:@"10" leading:@"10" bottom:nil trailing:@"-10" toView:self.usernameLayout.superview];
    [self.usernameLayout constrainHeight:@"40"];
    NSArray* inputlayouts = @[self.usernameLayout, self.passwordText];
    [UIView spaceOutViewsVertically:inputlayouts predicate:@"10"];
    [UIView alignLeadingEdgesOfViews:inputlayouts];
    [UIView alignTrailingEdgesOfViews:inputlayouts];
    
    [self.buttonLayout constrainWidth:mainLayoutWidth height:@"44"];
    [self.signUpLayout alignTop:nil leading:nil toView:self.signUpButton.superview];
    [self.signUpLayout constrainWidth:[NSString stringWithFormat:@"%f", width * 0.4] height:@"44"];
    NSArray* buttonLayouts = @[self.signUpLayout, self.logInLayout];
    [UIView spaceOutViewsHorizontally:buttonLayouts predicate:nil];
    [UIView alignTopEdgesOfViews:buttonLayouts];
    [UIView alignBottomEdgesOfViews:buttonLayouts];
    [UIView equalWidthForViews:buttonLayouts];
    [self.signUpButton alignCenterWithView:self.signUpButton.superview];
    [self.logInButton alignCenterWithView:self.logInButton.superview];
    
    [self.inputLayout alignTop:nil leading:nil toView:self.inputLayout.superview];
    [self.inputLayout constrainWidth:mainLayoutWidth height:@"100"];
    NSArray* mainLayouts = @[self.inputLayout, self.buttonLayout];
    [UIView spaceOutViewsVertically:mainLayouts predicate:@"20"];
    [UIView alignLeadingEdgesOfViews:mainLayouts];
    [UIView alignTrailingEdgesOfViews:mainLayouts];
}

- (void)initSceneModel {
    self.sceneModel = [SignInSceneModel SceneModel];
    self.sceneModel.code = @"+61";
    
    [self.sceneModel.request onRequest:^() {
        NSString* username = self.sceneModel.request.profile.objectId;
        NSString* password = self.passwordText.text;
        @weakify(self)
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                            password:password
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *error) {
             @strongify(self)
             if (loginInfo && !error) {
                 [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                 EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                 if (!error) {
                     error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                 }
                 
                 [KeyChainUtil setToken:self.sceneModel.request.profile.sessionToken];
                 [KeyChainUtil setCurrentUserId:self.sceneModel.request.profile.objectId];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:@YES];
             } else {
                 switch (error.errorCode) {
                     case EMErrorNotFound:
                         [self hideHudFailed:(error.description)];
                         break;
                     case EMErrorNetworkNotConnected:
                         [self hideHudFailed:NSLocalizedString(@"error.connectNetworkFail", nil)];
                         break;
                     case EMErrorServerNotReachable:
                         [self hideHudFailed:NSLocalizedString(@"error.connectServerFail", nil)];
                         break;
                     case EMErrorServerAuthenticationFailure:
                         [self hideHudFailed:error.description];
                         break;
                     case EMErrorServerTimeout:
                         [self hideHudFailed:NSLocalizedString(@"error.connectServerTimeout", nil)];
                         break;
                     default:
                         [self hideHudFailed:NSLocalizedString(@"login.fail", nil)];
                         break;
                 }
             }
         } onQueue:nil];
    } error:^(NSError *error) {
        [self hideHudFailed:error.localizedDescription];
    }];
}

- (void)bindToSceneModel {
    [self.codeButton rac_liftSelector:@selector(setTitle:forState:) withSignals:RACObserve(self.sceneModel, code), [RACSignal return:@(UIControlStateNormal)], nil];
    RAC(self.sceneModel, username) = self.usernameText.rac_textSignal;
    RAC(self.sceneModel, password) = self.passwordText.rac_textSignal;
    [[[RACSignal combineLatest:@[RACObserve(self.sceneModel, username), RACObserve(self.sceneModel, password)]] reduceEach:^id(NSString* username, NSString* password){
        return @([self.sceneModel isValid]);
    }] subscribeNext:^(NSNumber* loginButtonEnabled) {
        [self.logInButton setEnabled:[loginButtonEnabled boolValue]];
    }];
}

- (void)codeButtonPressed {
    CountryScene* countryScene = [[CountryScene alloc] init];
    countryScene.delegate = self;
    [self.navigationController pushViewController:countryScene animated:YES];
}

- (void)loginButtonPressed {
    [self showHudIndeterminate:@"正在验证账号信息"];
    NSString* username = [self.sceneModel.code stringByAppendingFormat:@"%lld", [self.sceneModel.username longLongValue]];
    [self.sceneModel.request doLogin:username password:self.sceneModel.password];
}

- (void)signUpButtonPressed {
    [URLManager pushURLString:@"iosapp://signUp" animated:YES];
}

- (void)getCountry:(Country *)country {
    self.sceneModel.code = country.code;
}

@end
