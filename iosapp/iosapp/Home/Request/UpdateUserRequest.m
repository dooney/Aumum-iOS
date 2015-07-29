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

- (void)send:(NSString*)userId screenName:(NSString*)screenName avatarUrl:(NSString*)avatarUrl {
    self.PATH = [NSString stringWithFormat:@"/1/users/%@", userId];
    self.screenName = screenName;
    self.avatarUrl = avatarUrl;
    [self send];
}

@end
