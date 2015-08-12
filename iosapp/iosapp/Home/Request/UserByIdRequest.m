//
//  UserByIdRequest.m
//  iosapp
//
//  Created by Simpson Du on 11/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserByIdRequest.h"
#import "UserList.h"
#import "NSString+EasyExtend.h"

@implementation UserByIdRequest

- (void)loadRequest {
    [super loadRequest];
    self.METHOD = @"GET";
    self.keys = [User getKeys];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    if ([output objectForKey:@"results"]) {
        UserList* list = [[UserList alloc] initWithDictionary:self.output error:&error];
        self.user = [list.results firstObject];
    } else {
        self.user = [[User alloc] initWithDictionary:output error:&error];
    }
    [self.user insertOrReplace:self.user.objectId];
    return error;
}

- (void)getById:(NSString*)userId {
    self.PATH = [NSString stringWithFormat:@"/1/users/%@", userId];
    self.user = nil;
    self.where = nil;
    [self send];
}

- (void)getByChatId:(NSString*)chatId {
    self.PATH = [NSString stringWithFormat:@"/1/users"];
    self.where = [NSString jsonStringWithDictionary:@{ @"chatId": chatId }];
    self.user = nil;
    [self send];
}

@end
