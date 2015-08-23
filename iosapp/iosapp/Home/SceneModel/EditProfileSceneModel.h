//
//  EditProfileSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 22/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_EditProfileSceneModel_h
#define iosapp_EditProfileSceneModel_h

#import "BaseSceneModel.h"
#import "UpdateUserRequest.h"
#import "Profile.h"

@interface EditProfileSceneModel : BaseSceneModel

@property (nonatomic, strong) UpdateUserRequest* request;
@property (nonatomic, strong) Profile* profile;

@end

#endif
