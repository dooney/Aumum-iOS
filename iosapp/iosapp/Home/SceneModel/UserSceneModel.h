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
#import "Profile.h"
#import "MomentListRequest.h"

@interface UserSceneModel : BaseSceneModel

@property (nonatomic, strong)UserDetailsRequest* request;
@property (nonatomic, strong)Profile* profile;
@property (nonatomic, strong)MomentListRequest* momentListRequest;

@end

#endif
