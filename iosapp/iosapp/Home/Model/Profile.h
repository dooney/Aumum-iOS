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
#import "User.h"

@interface Profile : BaseModel

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString<Optional>* sessionToken;
@property (nonatomic, strong)NSString<Optional>* chatId;
@property (nonatomic, strong)NSString<Optional>* screenName;
@property (nonatomic, strong)NSString<Optional>* avatarUrl;
@property (nonatomic, strong)NSString<Optional>* country;
@property (nonatomic, strong)NSString<Optional>* city;
@property (nonatomic, strong)NSString<Optional>* email;
@property (nonatomic, strong)NSString<Optional>* about;
@property (nonatomic, strong)NSMutableArray<Optional>* contacts;
@property (nonatomic, strong)NSString<Ignore>* contactList;

+ (id)get;
+ (User*)getUser;
- (void)updateContactList;

@end

@protocol Profile

@end

#endif
