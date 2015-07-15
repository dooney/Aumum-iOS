//
//  ChatSceneModel.m
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ChatSceneModel.h"

@implementation ChatSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self);
    self.userRequest = [UserRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.userRequest];
    }];
}

@end
