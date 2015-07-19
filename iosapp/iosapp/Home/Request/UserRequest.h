//
//  UserRequest.h
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UserRequest_h
#define iosapp_UserRequest_h

#import "BaseRequest.h"
#import "User.h"

@interface UserRequest : BaseRequest

@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSString* keys;

- (void)send:(NSString*)userId;

@end

#endif
