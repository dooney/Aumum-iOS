//
//  Profile.h
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Auth_h
#define iosapp_Auth_h

#import "BaseModel.h"

@interface Profile : BaseModel

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString<Optional>* sessionToken;
@property (nonatomic, strong)NSString* chatId;
@property (nonatomic, strong)NSString* screenName;
@property (nonatomic, strong)NSString* avatarUrl;

+ (id)get;

@end

@protocol Profile

@end

#endif
