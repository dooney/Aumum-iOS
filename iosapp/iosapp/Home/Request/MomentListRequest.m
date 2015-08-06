//
//  MomentListRequest.m
//  iosapp
//
//  Created by Simpson Du on 1/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentListRequest.h"
#import "NSString+EasyExtend.h"

#define LIMIT 12

@implementation MomentListRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/classes/Moments";
    self.METHOD = @"GET";
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.list = [[MomentList alloc] initWithDictionary:self.output error:&error];
    for (Moment* moment in self.list.results) {
        if (!moment.likes) {
            moment.likes = [NSMutableArray array];
        }
        [moment insertOrReplace:moment.objectId];
    }
    if (self.list.results.count < LIMIT) {
        self.isEnd = @(YES);
    }
    return error;
}

- (void)send:(NSString*)before after:(NSString*)after {
    NSInteger limit = LIMIT;
    if (before || after) {
        NSMutableDictionary* opJson = [NSMutableDictionary dictionary];
        NSMutableDictionary* dateJson = [NSMutableDictionary dictionary];
        [dateJson setValue:@"Date" forKey:@"__type"];
        if (before) {
            [dateJson setValue:before forKey:@"iso"];
            [opJson setValue:dateJson forKey:@"$lt"];
        } else {
            [dateJson setValue:after forKey:@"iso"];
            [opJson setValue:dateJson forKey:@"$gt"];
            limit = NSIntegerMax;
        }
        NSDictionary* whereJson = @{ @"createdAt": opJson };
        self.where = [NSString jsonStringWithDictionary:whereJson];
    }
    self.order = @"-createdAt";
    self.limit = [NSString stringWithFormat:@"%d", limit];
    self.list = nil;
    [self send];
}

@end
