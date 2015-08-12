//
//  UserByIdRequest.h
//  iosapp
//
//  Created by Simpson Du on 11/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UserByIdRequest_h
#define iosapp_UserByIdRequest_h

#import "BaseRequest.h"
#import "User.h"

@interface UserByIdRequest : BaseRequest

@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSString* keys;
@property (nonatomic, strong) NSString* where;

- (void)getById:(NSString*)userId;
- (void)getByChatId:(NSString*)chatId;

@end

#endif
