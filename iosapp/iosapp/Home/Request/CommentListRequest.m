//
//  CommentListRequest.m
//  iosapp
//
//  Created by Simpson Du on 3/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "CommentListRequest.h"
#import "NSString+EasyExtend.h"

#define LIMIT 15

@implementation CommentListRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/classes/MomentComments";
    self.METHOD = @"GET";
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.list = [[CommentList alloc] initWithDictionary:self.output error:&error];
    for (Comment* comment in self.list.results) {
        [comment insertOrReplace:comment.objectId];
    }
    if (self.list.results.count < LIMIT) {
        self.isEnd = @(YES);
    }
    return error;
}

- (void)send:(NSString*)momentId {
    NSInteger limit = LIMIT;
    NSDictionary* whereJson = @{ @"parentId": momentId };
    self.where = [NSString jsonStringWithDictionary:whereJson];
    self.order = @"-createdAt";
    self.limit = [NSString stringWithFormat:@"%d", limit];
    self.list = nil;
    [self send];
}

@end
