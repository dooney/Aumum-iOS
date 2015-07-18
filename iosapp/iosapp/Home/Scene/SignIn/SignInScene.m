//
//  SignInScene.m
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "SignInScene.h"
#import "JVFloatLabeledTextField.h"
#import "UIView+FLKAutoLayout.h"
#import "SignInSceneModel.h"
#import "UIViewController+MBHud.h"
#import "KeyChainUtil.h"
#import "EaseMob.h"
#import "UIButton+NUI.h"

@interface SignInScene()<UITextFieldDelegate>

@property (nonatomic, strong)JVFloatLabeledTextField* usernameText;
@property (nonatomic, strong)JVFloatLabeledTextField* passwordText;
@property (nonatomic, strong)UIButton* loginButton;

@property (nonatomic, strong)SignInSceneModel* sceneModel;

@end

@implementation SignInScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addControls];
    [self loadAutoLayout];
    [self initSceneModel];
    [self bindToSceneModel];
}

- (void)addControls {
    self.usernameText = [[JVFloatLabeledTextField alloc] init];
    [self.usernameText setPlaceholder:NSLocalizedString(@"label.username", @"Username")];
    self.usernameText.delegate = self;
    [self.view addSubview:self.usernameText];
    
    self.passwordText = [[JVFloatLabeledTextField alloc] init];
    self.passwordText.secureTextEntry = YES;
    [self.passwordText setPlaceholder:NSLocalizedString(@"label.password", @"Password")];
    self.passwordText.delegate = self;
    [self.view addSubview:self.passwordText];
    
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setTitle:NSLocalizedString(@"label.login", @"Login") forState:UIControlStateNormal];
    self.loginButton.nuiClass = @"Button:largeButton";
    [self.loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    [self loadHud:self.view];
}

- (void)loadAutoLayout {
    NSMutableArray* views = [[NSMutableArray alloc] initWithObjects:
                             self.usernameText, self.passwordText, self.loginButton, nil];
    
    [self.usernameText alignCenterXWithView:self.usernameText.superview predicate:nil];
    [self.usernameText alignCenterYWithView:self.usernameText.superview predicate:nil];
    [self.usernameText constrainWidth:@"200" height:@"40"];
    
    [UIView spaceOutViewsVertically:views predicate:@"20"];
    [UIView alignLeadingEdgesOfViews:views];
    [UIView alignTrailingEdgesOfViews:views];
}

- (void)initSceneModel {
    self.sceneModel = [SignInSceneModel SceneModel];
    
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
                         [self hideHudFailed:NSLocalizedString(@"error.connectNetworkFail", @"No network connection!")];
                         break;
                     case EMErrorServerNotReachable:
                         [self hideHudFailed:NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!")];
                         break;
                     case EMErrorServerAuthenticationFailure:
                         [self hideHudFailed:error.description];
                         break;
                     case EMErrorServerTimeout:
                         [self hideHudFailed:NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!")];
                         break;
                     default:
                         [self hideHudFailed:NSLocalizedString(@"login.fail", @"Login failure")];
                         break;
                 }
             }
         } onQueue:nil];
    } error:^(NSError *error) {
        [self hideHudFailed:error.localizedDescription];
    }];
}

- (void)bindToSceneModel {
    RAC(self.sceneModel, username) = self.usernameText.rac_textSignal;
    RAC(self.sceneModel, password) = self.passwordText.rac_textSignal;
    [[[RACSignal combineLatest:@[RACObserve(self.sceneModel, username), RACObserve(self.sceneModel, password)]] reduceEach:^id(NSString* username, NSString* password){
        return @([self.sceneModel isValid]);
    }] subscribeNext:^(NSNumber* loginButtonEnabled) {
        [self.loginButton setEnabled:[loginButtonEnabled boolValue]];
    }];
}

- (void)loginButtonAction {
    [self showHudIndeterminate:@"正在验证账号信息，请稍候"];
    [self.sceneModel.request doLogin:self.sceneModel.username password:self.sceneModel.password];
}

@end
