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
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.list = [[UserList alloc] initWithDictionary:self.output error:&error];
    for (User* user in self.list.results) {
        [user insertOrReplace:user.objectId];
    }
    return error;
}

- (void)send:(NSArray *)chatIdList {
    self.where = [NSString jsonStringWithDictionary:@{ @"chatId": @{ @"$in": chatIdList } }];
    self.keys = [User getKeys];
    self.list = nil;
    [self send];
}

@end