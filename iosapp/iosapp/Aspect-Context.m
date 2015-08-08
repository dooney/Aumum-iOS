//
//  Aspect-Context.m
//  iosapp
//
//  Created by Simpson Du on 5/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <XAspect/XAspect.h>
#import "Tab.h"

#define AtAspect  Context

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    self.database = [[CustomDatabase alloc] initWithMigrations:YES];
    Tab* homeTab = [Tab getById:@"Home"];
    if (!homeTab) {
        homeTab = [[Tab alloc] initWithId:@"Home"];
        [homeTab save];
    }
    Tab* notificationTab = [Tab getById:@"Notification"];
    if (!notificationTab) {
        notificationTab = [[Tab alloc] initWithId:@"Notification"];
        [notificationTab save];
    }
    
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
