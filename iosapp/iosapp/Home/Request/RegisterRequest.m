//
//  RegisterRequest.m
//  iosapp
//
//  Created by Simpson Du on 28/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "RegisterRequest.h"
#import "Profile.h"

@implementation RegisterRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/users";
    self.METHOD = @"POST";
}

- (void)doRegister:(NSString*)username password:(NSString*)password {
    self.username = username;
    self.password = password;
    self.profile = nil;
    [self send];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.profile = [[Profile alloc] initWithDictionary:output error:&error];
    [self.profile insertOrReplace:self.profile.objectId];
    return error;
}

@end
