//
//  Aspect-Util.m
//  iosapp
//
//  Created by Simpson Du on 5/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import "FLEXManager.h"
#import "AFNetworkActivityLogger.h"

#define AtAspect  Util

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    [[FLEXManager sharedManager] showExplorer];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass
#undef AtAspect