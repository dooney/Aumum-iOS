//
//  NewCommentRequest.m
//  iosapp
//
//  Created by Simpson Du on 5/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "NewCommentRequest.h"

@implementation NewCommentRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/classes/MomentComments";
    self.METHOD = @"POST";
}

- (void)send:(Comment*)comment {
    self.userId = comment.userId;
    self.parentId = comment.parentId;
    self.content = comment.content;
    [self send];
}

@end
