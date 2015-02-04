//
//  BaseSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 3/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "BaseSceneModel.h"
#import "GCDMacros.h"

@interface BaseSceneModel ()

+ (instancetype)sharedInstance;
- (void)loadData;

@end

@implementation BaseSceneModel

+ (instancetype)sharedInstance {
    GCDSharedInstance(^{ return [self SceneModel]; });
}

- (void)loadData {
}

@end
