//
//  ProfileSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 15/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ProfileSceneModel_h
#define iosapp_ProfileSceneModel_h

#import "SceneModel.h"
#import "ProfileRequest.h"

@interface ProfileSceneModel : SceneModel

@property (nonatomic, strong)ProfileRequest* request;

@end

#endif
