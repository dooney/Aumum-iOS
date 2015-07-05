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
#import "MomentList.h"
#import "UserListRequest.h"
#import "UserList.h"

@interface MomentListSceneModel : SceneModel

@property (nonatomic, strong) MomentListRequest* request;
@property (nonatomic, strong) MomentList* list;
@property (nonatomic, strong) NSMutableArray* dataSet;
@property (nonatomic, strong) UserListRequest* userListRequest;
@property (nonatomic, strong) UserList* userList;

@end

#endif
