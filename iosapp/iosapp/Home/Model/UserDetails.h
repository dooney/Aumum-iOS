//
//  UserDetails.h
//  iosapp
//
//  Created by Simpson Du on 19/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UserDetails_h
#define iosapp_UserDetails_h

#import "BaseModel.h"

@interface UserDetails : BaseModel

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* chatId;
@property (nonatomic, strong)NSString* screenName;
@property (nonatomic, strong)NSString<Optional>* avatarUrl;
@property (nonatomic, strong)NSString* country;
@property (nonatomic, strong)NSString* city;

+ (NSString*)getKeys;

@end

@protocol UserDetails

@end

#endif
