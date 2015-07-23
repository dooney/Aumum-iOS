//
//  ProfileScene.m
//  iosapp
//
//  Created by Simpson Du on 9/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ProfileScene.h"
#import "UIView+FLKAutoLayout.h"
#import "KeyChainUtil.h"
#import "UIViewController+MBHud.h"
#import "EaseMob.h"

@interface ProfileScene()

@property (nonatomic, strong)UIButton* logoutButton;

@end

@implementation ProfileScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addControls];
    [self loadAutoLayout];
    [self initSceneModel];
}

- (void)addControls {
    self.logoutButton = [[UIButton alloc] init];
    [self.logoutButton setTitle:NSLocalizedString(@"label.logOut", @"Log Out") forState:UIControlStateNormal];
    self.logoutButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self showHudIndeterminate:@"正在退出登录"];
        @weakify(self)
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            @strongify(self)
            if (error && error.errorCode != EMErrorServerNotLogin) {
                [self hideHudFailed:error.description];
            } else {
                [KeyChainUtil resetToken];
                [KeyChainUtil resetCurrentUserId];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:@NO];
            }
        } onQueue:nil];
        return [RACSignal empty];
    }];
    [self.view addSubview:self.logoutButton];
    
    [self loadHud:self.view];
}

- (void)loadAutoLayout {
    [self.logoutButton alignCenterWithView:self.logoutButton.superview];
}

- (void)initSceneModel {
    self.sceneModel = [ProfileSceneModel SceneModel];
    [self.sceneModel.request send];
}

@end
