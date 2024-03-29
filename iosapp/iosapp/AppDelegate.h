//
//  AppDelegate.h
//  iosapp
//
//  Created by Simpson Du on 1/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"
#import "CustomDatabase.h"
#import "ContextSceneModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomDatabase* database;
@property (strong, nonatomic) ContextSceneModel* sceneModel;

@end

