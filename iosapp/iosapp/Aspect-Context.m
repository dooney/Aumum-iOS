//
//  Aspect-Context.m
//  iosapp
//
//  Created by Simpson Du on 5/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>

#define AtAspect  Context

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    self.database = [[CustomDatabase alloc] initWithMigrations:YES];
    
    self.sceneModel = [ContextSceneModel SceneModel];
    [self.sceneModel.profileRequest send];
    [self.sceneModel.profileRequest onRequest:^{
        NSLog(@"Get profile - OK");
    } error:^(NSError *error) {
        NSLog(@"Get profile failed: %@", error.localizedDescription);
    }];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
@end
#undef AtAspectOfClass
#undef AtAspect
