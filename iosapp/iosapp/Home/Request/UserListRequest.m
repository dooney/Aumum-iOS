//
//  UserListRequest.m
//  iosapp
//
//  Created by Administrator on 5/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserListRequest.h"
#import "NSString+EasyExtend.h"

@implementation UserListRequest

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

- (void)send:(NSArray *)userIdList {
    self.where = [NSString jsonStringWithDictionary:@{ @"objectId": @{ @"$in": userIdList } }];
    self.keys = @"objectId,chatId,avatarUrl,screenName";
    self.list = nil;
    [self send];
}

@end


