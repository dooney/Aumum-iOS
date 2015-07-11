//
//  ProfileScene.m
//  iosapp
//
//  Created by Simpson Du on 9/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ProfileScene.h"
#import "UIColor+EasyExtend.h"
#import "Constants.h"
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
    
    self.logoutButton = [[UIButton alloc] initNavigationButtonWithTitle:@"Log Out" color:HEX_RGB(AM_YELLOW)];
    self.logoutButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self showHudIndeterminate:@"正在退出登录，请稍候"];
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
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
    
    [self loadAutoLayout];
    
    [self loadHud:self.view];
}

- (void)loadAutoLayout {
    [self.logoutButton alignToView:self.logoutButton.superview];
}

@end
