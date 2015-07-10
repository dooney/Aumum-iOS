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

#define AtAspect Window

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)

AspectPatch(-, void,application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions) {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor flatWhiteColor];
    
    if ([KeyChainUtil getToken] != nil) {
        TabBarController *tabBarController = [[TabBarController alloc]init];
        self.window.rootViewController = tabBarController;
    } else {
        RDNavigationController* splashController = [[RDNavigationController alloc] initWithRootViewController:[[SplashScene alloc] init]];
        self.window.rootViewController = splashController;
    }
    [self.window makeKeyAndVisible];
    
    [[$ rac_didNetworkChanges]
     subscribeNext:^(NSNumber *status) {
         AFNetworkReachabilityStatus networkStatus = [status intValue];
         switch (networkStatus) {
             case AFNetworkReachabilityStatusUnknown:
             case AFNetworkReachabilityStatusNotReachable:
                 [[DialogUtil sharedInstance] showDlg:self.window textOnly:@"网络连接不给力"];
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
    
    XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass

#undef AtAspect