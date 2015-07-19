//
//  UserListByChatIdRequest.h
//  iosapp
//
//  Created by Simpson Du on 14/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UserListByChatIdRequest_h
#define iosapp_UserListByChatIdRequest_h

#import "BaseRequest.h"
#import "UserList.h"

@interface UserListByChatIdRequest : BaseRequest

@property (nonatomic, strong) UserList* list;
@property (nonatomic, strong) NSString* where;
@property (nonatomic, strong) NSString* keys;

- (void)send:(NSArray *)chatIdList;

@end

#endif
