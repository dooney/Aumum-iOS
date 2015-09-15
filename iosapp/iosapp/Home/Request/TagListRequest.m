//
//  TagListRequest.m
//  iosapp
//
//  Created by Simpson Du on 14/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "TagListRequest.h"
#import "NSString+EasyExtend.h"

@implementation TagListRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/classes/Tags";
    self.METHOD = @"GET";
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.list = [[TagList alloc] initWithDictionary:self.output error:&error];
    return error;
}

- (void)getList:(NSArray*)tagList {
    self.where = [NSString jsonStringWithDictionary:@{ @"text": @{ @"$in": tagList } }];
    self.list = nil;
    [self send];
}

@end
