//
//  UserListByChatIdRequest.m
//  iosapp
//
//  Created by Simpson Du on 14/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserListByChatIdRequest.h"
#import "NSString+EasyExtend.h"

@implementation UserListByChatIdRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/users";
    self.METHOD = @"GET";
    [self.params setValue:@"objectId,chatId,avatarUrl,screenName" forKey:@"keys"];
}

- (void)setChatIdList:(NSArray *)chatIdList {
    NSDictionary* inJson = @{ @"$in": chatIdList };
    NSDictionary* whereJson = @{ @"chatId": inJson };
    [self.params setValue:[NSString jsonStringWithDictionary:whereJson] forKey:@"where"];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.list = [[UserList alloc] initWithDictionary:self.output error:&error];
    return error;
}

@end