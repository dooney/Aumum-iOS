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
#import "UIButton+EasyExtend.h"
#import "Constants.h"
#import "SignInSceneModel.h"
#import "UIViewController+MBHud.h"
#import "KeyChainUtil.h"
#import "TabBarController.h"

@interface SignInScene()

@property (nonatomic, strong)JVFloatLabeledTextField* userNameText;
@property (nonatomic, strong)JVFloatLabeledTextField* passwordText;
@property (nonatomic, strong)UIButton* loginButton;

@property (nonatomic, strong)SignInSceneModel* sceneModel;

@end

@implementation SignInScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSceneModel];
    
    self.userNameText = [[JVFloatLabeledTextField alloc] init];
    [self.userNameText setPlaceholder:@"Username"];
    [self.view addSubview:self.userNameText];
    
    self.passwordText = [[JVFloatLabeledTextField alloc] init];
    self.passwordText.secureTextEntry = YES;
    [self.passwordText setPlaceholder:@"Password"];
    [self.view addSubview:self.passwordText];
    
    self.loginButton = [[UIButton alloc] initNavigationButtonWithTitle:@"Log In" color:HEX_RGB(AM_YELLOW)];
    self.loginButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self showHudIndeterminate:@"正在验证账号信息，请稍候"];
        NSString* userName = self.userNameText.text;
        NSString* password = self.passwordText.text;
        [self.sceneModel.request setAuthInfo:userName password:password];
        self.sceneModel.request.requestNeedActive = YES;
        return [RACSignal empty];
    }];
    [self.view addSubview:self.loginButton];
    
    [self loadAutoLayout];
    
    [self loadHud:self.view];
}

- (void)loadAutoLayout {
    NSMutableArray* views = [[NSMutableArray alloc] initWithObjects:
                             self.userNameText, self.passwordText, self.loginButton, nil];
    
    [self.userNameText alignCenterXWithView:self.userNameText.superview predicate:nil];
    [self.userNameText alignCenterYWithView:self.userNameText.superview predicate:nil];
    [self.userNameText constrainWidth:@"200" height:@"40"];
    
    [UIView spaceOutViewsVertically:views predicate:@"20"];
    [UIView alignLeadingEdgesOfViews:views];
    [UIView alignTrailingEdgesOfViews:views];
}

- (void)initSceneModel {
    self.sceneModel = [SignInSceneModel SceneModel];
    
    [self.sceneModel onRequest:^(Auth *auth) {
        [KeyChainUtil setToken:auth.sessionToken];
        [KeyChainUtil setCurrentUserId:auth.objectId];
        TabBarController *tabBarController = [[TabBarController alloc] init];
        [self presentViewController:tabBarController animated:YES completion:nil];
    } error:^(NSError *error) {
        [self hideHudFailed:error.localizedDescription];
    } done:^{
        [self hideHud];
    }];
}

@end
