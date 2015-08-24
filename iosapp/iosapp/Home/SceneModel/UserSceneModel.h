//
//  UserSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 19/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UserSceneModel_h
#define iosapp_UserSceneModel_h

#import "BaseSceneModel.h"
#import "UserDetailsRequest.h"
#import "MomentListRequest.h"
#import "UpdateUserRequest.h"

@interface UserSceneModel : BaseSceneModel

@property (nonatomic, strong)UserDetailsRequest* request;
@property (nonatomic, strong)MomentListRequest* momentListRequest;
@property (nonatomic, strong)UpdateUserRequest* updateUserRequest;

@end

#endif
