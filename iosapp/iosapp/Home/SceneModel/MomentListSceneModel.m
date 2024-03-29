//
//  MomentListSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 1/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentListSceneModel.h"

@implementation MomentListSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self);
    self.pullRequest = [MomentListRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.pullRequest];
    }];
    
    self.loadRequest = [MomentListRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.loadRequest];
    }];
    
    self.userListRequest = [UserListRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.userListRequest];
    }];
}

@end
