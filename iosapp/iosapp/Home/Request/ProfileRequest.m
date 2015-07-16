//
//  ProfileRequest.m
//  iosapp
//
//  Created by Simpson Du on 15/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ProfileRequest.h"
#import "KeyChainUtil.h"
#import "Profile.h"

@implementation ProfileRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/users/me";
    self.METHOD = @"GET";
    [self.httpHeaderFields setValue:[KeyChainUtil getToken] forKey:@"X-Parse-Session-Token"];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    Profile* profile = [[Profile alloc] initWithDictionary:output error:&error];
    [profile insertOrReplace:profile.objectId];
    return error;
}

@end
