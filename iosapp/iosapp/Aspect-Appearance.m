//
//  Aspect-Appearance.m
//  iosapp
//
//  Created by Simpson Du on 21/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import "UIColor+MLPFlatColors.h"
#import "NUISettings.h"

#define AtAspect  Appearance

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions) {
    [NUISettings init];
    [NUISettings initWithStylesheet:@"AMStyle"];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass
#undef AtAspect
