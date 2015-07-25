//
//  Aspect-ShareSDK.m
//  iosapp
//
//  Created by Simpson Du on 25/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import <SMS_SDK/SMS_SDK.h>

#define AtAspect  ShareSDK

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    [SMS_SDK registerApp:@"4b3aee0612e8" withSecret:@"f6477ba59f492d8d04ca97378236da46"];
    [SMS_SDK enableAppContactFriends:NO];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass
#undef AtAspect
