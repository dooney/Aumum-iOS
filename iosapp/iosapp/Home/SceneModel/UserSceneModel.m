//
//  UserSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 19/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserSceneModel.h"

@implementation UserSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self)
    self.request = [UserDetailsRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
    self.momentListRequest = [MomentListRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.momentListRequest];
    }];
    self.updateUserRequest = [UpdateUserRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.updateUserRequest];
    }];
}

@end
