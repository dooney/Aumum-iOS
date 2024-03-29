//
//  AvatarSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 28/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_AvatarSceneModel_h
#define iosapp_AvatarSceneModel_h

#import "BaseSceneModel.h"
#import "UpdateUserRequest.h"
#import "NewMomentRequest.h"

@interface AvatarSceneModel : BaseSceneModel

@property (nonatomic, strong)UpdateUserRequest* request;
@property (nonatomic, strong)NSString* userId;
@property (nonatomic, strong)NSString* chatId;
@property (nonatomic, strong)NewMomentRequest* momentRequest;

@end

#endif
