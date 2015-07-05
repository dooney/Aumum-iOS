//
//  User.h
//  iosapp
//
//  Created by Administrator on 5/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_User_h
#define iosapp_User_h

#import "Model.h"

@interface User : Model

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* screenName;
@property (nonatomic, strong)NSString* avatarUrl;

@end

@protocol User

@end

#endif
