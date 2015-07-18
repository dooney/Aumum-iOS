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
    [self.params setValue:@"objectId,chatId,avatarUrl,screenName" forKey:@"keys"];
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
    NSDictionary* inJson = @{ @"$in": userIdList };
    NSDictionary* whereJson = @{ @"objectId": inJson };
    [self.params setValue:[NSString jsonStringWithDictionary:whereJson] forKey:@"where"];
    [self send];
}

@end


