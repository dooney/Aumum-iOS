//
//  Comment.h
//  iosapp
//
//  Created by Simpson Du on 3/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Comment_h
#define iosapp_Comment_h

#import "BaseModel.h"
#import "User.h"

@interface Comment: BaseModel

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* userId;
@property (nonatomic, strong)NSString* createdAt;
@property (nonatomic, strong)NSString* parentId;
@property (nonatomic, strong)NSString* content;
@property (nonatomic, strong)User<Ignore>* user;

@end

@protocol Comment

@end

#endif
