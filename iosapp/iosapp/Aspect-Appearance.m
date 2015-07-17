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
    NSString* path = @"/Users/simpsondu/Workspace/Aumum-iOS/iosapp/iosapp/Home/Resource/AMStyle.nss";
    [NUISettings setAutoUpdatePath:path];
    [NUISettings loadStylesheetByPath:path];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass
#undef AtAspect
