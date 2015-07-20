//
//  UserDetailsRequest.m
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserDetailsRequest.h"

@implementation UserDetailsRequest

- (void)loadRequest {
    [super loadRequest];
    self.METHOD = @"GET";
    self.keys = [UserDetails getKeys];
}

- (void)send:(NSString*)userId {
    self.PATH = [NSString stringWithFormat:@"/1/users/%@", userId];
    self.userDetails = nil;
    [self send];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.userDetails = [[UserDetails alloc] initWithDictionary:output error:&error];
    return error;
}

@end
