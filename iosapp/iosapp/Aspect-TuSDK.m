//
//  Aspect-TuSDK.m
//  iosapp
//
//  Created by Simpson Du on 26/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import <TuSDK/TuSDK.h>

#define AtAspect  TuSDK

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    [TuSDK initSdkWithAppKey:@"41c786ff4a971ef7-00-2j9nn1"];
    [TuSDK setLogLevel:lsqLogLevelDEBUG];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass
#undef AtAspect
