//
//  UpdateUserRequest.h
//  iosapp
//
//  Created by Simpson Du on 28/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UpdateUserRequest_h
#define iosapp_UpdateUserRequest_h

#import "BaseRequest.h"

@interface UpdateUserRequest : BaseRequest

@property (nonatomic, strong)NSString* chatId;
@property (nonatomic, strong)NSString* screenName;
@property (nonatomic, strong)NSString* avatarUrl;
@property (nonatomic, strong)NSString* country;
@property (nonatomic, strong)NSString* city;
@property (nonatomic, strong)NSString* email;
@property (nonatomic, strong)NSString* about;

- (void)send:(NSString*)userId
      chatId:(NSString*)chatId
  screenName:(NSString*)screenName
   avatarUrl:(NSString*)avatarUrl;

- (void)send:(NSString*)userId
  screenName:(NSString*)screenName
     country:(NSString*)country
        city:(NSString*)city
       email:(NSString*)email
       about:(NSString*)about;

- (void)send:(NSString*)userId avatarUrl:(NSString*)avatarUrl;

@end

#endif
