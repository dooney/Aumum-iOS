//
//  Aspect-QiniuSDK.m
//  iosapp
//
//  Created by Simpson Du on 28/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import "QiniuToken.h"

#define AtAspect  QiniuSDK

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    [QiniuToken registerWithScope:@"aumum" SecretKey:@"e5iufo1CZ9Pg34ZA5I88TPwA_BR5VlDVniWBRKes" Accesskey:@"bP2yEOI2QzgppmJ6tzXphUr2W6CdUq6CuKKr6cp3"];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass
#undef AtAspect
