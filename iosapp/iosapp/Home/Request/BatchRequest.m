//
//  BatchRequest.m
//  iosapp
//
//  Created by Simpson Du on 14/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "BatchRequest.h"

@implementation BatchRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/batch";
    self.METHOD = @"POST";
    self.requests = [NSMutableArray array];
}

@end
