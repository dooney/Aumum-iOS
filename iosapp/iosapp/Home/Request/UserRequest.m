//
//  UserRequest.m
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserRequest.h"

@implementation UserRequest

- (void)loadRequest {
    [super loadRequest];
    self.METHOD = @"GET";
    [self.params setValue:@"objectId,chatId,avatarUrl,screenName" forKey:@"keys"];
}

- (void)setUserId:(NSString*)userId {
    self.PATH = [NSString stringWithFormat:@"/1/users/%@", userId];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.user = [[User alloc] initWithDictionary:output error:&error];
    return error;
}

@end
