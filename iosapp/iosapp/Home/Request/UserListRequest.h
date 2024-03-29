//
//  UserListRequest.h
//  iosapp
//
//  Created by Administrator on 5/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UserListRequest_h
#define iosapp_UserListRequest_h

#import "BaseRequest.h"
#import "UserList.h"

@interface UserListRequest : BaseRequest

@property (nonatomic, strong) UserList* list;
@property (nonatomic, strong) NSString* where;
@property (nonatomic, strong) NSString* keys;

- (void)send:(NSArray *)userIdList;

@end

#endif
