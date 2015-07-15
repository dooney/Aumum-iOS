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

- (void)setAuthInfo:(NSString*)userName password:(NSString*)password {
    [self.params setValue:userName forKey:@"username"];
    [self.params setValue:password forKey:@"password"];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.auth = [[Auth alloc] initWithDictionary:self.output error:&error];
    return error;
}

@end
