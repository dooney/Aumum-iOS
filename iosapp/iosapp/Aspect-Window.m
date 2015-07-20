//
//  Aspect-Window.m
//  iosapp
//
//  Created by Simpson Du on 21/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import "TabBarController.h"
#import "EasyKit.h"
#import "AFNetworkReachabilityManager.h"
#import "DialogUtil.h"
#import "UIColor+MLPFlatColors.h"
#import "RDNavigationController.h"
#import "SplashScene.h"
#import "KeyChainUtil.h"
#import "TSMessage.h"

#define AtAspect Window

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)

AspectPatch(-, void,application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions) {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor flatWhiteColor];
    
    [self showRootController:[KeyChainUtil getToken] != nil];
    [self.window makeKeyAndVisible];
    
    [[$ rac_didNetworkChanges]
     subscribeNext:^(NSNumber *status) {
         AFNetworkReachabilityStatus networkStatus = [status intValue];
         switch (networkStatus) {
             case AFNetworkReachabilityStatusUnknown:
             case AFNetworkReachabilityStatusNotReachable:
                 [TSMessage showNotificationWithTitle:nil
                                             subtitle:@"无法找到有效的网络，请检查你的网络连接"
                                                 type:TSMessageNotificationTypeError];
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 [[DialogUtil sharedInstance] showDlg:self.window textOnly:@"当前使用移动数据网络"];
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 break;
             default:
                 break;
         }
     }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:@"loginStateChange"
                                               object:nil];
    
    XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}

- (void)showRootController:(BOOL)isLogin {
    if (isLogin) {
        TabBarController *tabBarController = [[TabBarController alloc]init];
        self.window.rootViewController = tabBarController;
    } else {
        RDNavigationController* splashController = [[RDNavigationController alloc] initWithRootViewController:[[SplashScene alloc] init]];
        self.window.rootViewController = splashController;
    }
}

- (void)loginStateChange:(NSNotification *)notification {
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    [self showRootController:isAutoLogin || loginSuccess];
}

@end
#undef AtAspectOfClass

#undef AtAspect