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
#import "MomentList.h"
#import "MomentListRequest.h"

@interface MomentListSceneModel : SceneModel

@property (nonatomic, strong) MomentList* list;
@property (nonatomic, strong) MomentListRequest* request;

@end

#endif
