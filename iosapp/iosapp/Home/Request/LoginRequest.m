//
//  LoginRequest.m
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/login";
    self.METHOD = @"GET";
}

- (void)doLogin:(NSString*)username password:(NSString*)password {
    self.username = username;
    self.password = password;
    self.profile = nil;
    [self send];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.profile = [[Profile alloc] initWithDictionary:self.output error:&error];
    [self.profile updateContactList];
    [self.profile insertOrReplace:self.profile.objectId];
    return error;
}

@end
