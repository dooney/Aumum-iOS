//
//  MomentListSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 1/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_MomentListSceneModel_h
#define iosapp_MomentListSceneModel_h

#import "SceneModel.h"
#import "MomentListRequest.h"
#import "UserListRequest.h"

@interface MomentListSceneModel : SceneModel

@property (nonatomic, strong) NSMutableArray* dataSet;
@property (nonatomic, strong) MomentListRequest* pullRequest;
@property (nonatomic, strong) MomentListRequest* loadRequest;
@property (nonatomic, strong) UserListRequest* userListRequest;

@end

#endif
