//
//  MomentDetailsSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 3/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentDetailsSceneModel.h"

@implementation MomentDetailsSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self);
    self.request = [CommentListRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
    
    self.userListRequest = [UserListRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.userListRequest];
    }];
    
    self.commentRequest = [NewCommentRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.commentRequest];
    }];
}

@end
