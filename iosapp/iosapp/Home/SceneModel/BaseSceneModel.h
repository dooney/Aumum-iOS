//
//  BaseSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 3/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "SceneModel.h"

@interface BaseSceneModel : SceneModel

@property(nonatomic, retain)NSDictionary* data;
@property(nonatomic, retain)NSString* error;

+ (instancetype)sharedInstance;
- (void)loadData;

@end
