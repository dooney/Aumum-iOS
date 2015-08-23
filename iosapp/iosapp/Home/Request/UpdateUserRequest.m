//
//  UpdateUserRequest.m
//  iosapp
//
//  Created by Simpson Du on 28/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UpdateUserRequest.h"
#import "KeyChainUtil.h"

@implementation UpdateUserRequest

- (void)loadRequest {
    [super loadRequest];
    self.METHOD = @"PUT";
    [self.httpHeaderFields setValue:[KeyChainUtil getToken] forKey:@"X-Parse-Session-Token"];
}

- (void)reset {
    self.chatId = nil;
    self.screenName = nil;
    self.avatarUrl = nil;
    self.country = nil;
    self.city = nil;
    self.email = nil;
    self.about = nil;
}

- (void)send:(NSString*)userId
      chatId:(NSString*)chatId
  screenName:(NSString*)screenName
   avatarUrl:(NSString*)avatarUrl {
    self.PATH = [NSString stringWithFormat:@"/1/users/%@", userId];
    self.chatId = chatId;
    self.screenName = screenName;
    self.avatarUrl = avatarUrl;
    [self send];
}

- (void)send:(NSString*)userId
  screenName:(NSString*)screenName
     country:(NSString*)country
        city:(NSString*)city
       email:(NSString*)email
       about:(NSString*)about {
    self.PATH = [NSString stringWithFormat:@"/1/users/%@", userId];
    self.screenName = screenName;
    self.country = country;
    self.city = city;
    self.email = email;
    self.about = about;
    [self send];
}

@end
