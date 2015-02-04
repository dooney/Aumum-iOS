//
//  AskingScene.m
//  iosapp
//
//  Created by Simpson Du on 2/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AskingScene.h"
#import "AskingSceneModel.h"

@interface AskingScene ()

- (BaseSceneModel*)getSceneModel;

@end

@implementation AskingScene

- (BaseSceneModel*)getSceneModel {
    return [AskingSceneModel sharedInstance];
}

@end
