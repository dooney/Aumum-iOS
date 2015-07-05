//
//  UserList.h
//  iosapp
//
//  Created by Administrator on 5/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UserList_h
#define iosapp_UserList_h

#import "Model.h"
#import "User.h"

@interface UserList : Model

@property (nonatomic, strong) NSMutableArray<User, Optional>* results;

@end

#endif
