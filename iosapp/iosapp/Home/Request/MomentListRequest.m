//
//  MomentListRequest.m
//  iosapp
//
//  Created by Simpson Du on 1/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentListRequest.h"

@implementation MomentListRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/classes/Moments";
    self.METHOD = @"GET";
    [self.params setValue:@"-createdAt" forKey:@"order"];
    [self.params setValue:[NSNumber numberWithInt:12] forKey:@"limit"];
}

@end
