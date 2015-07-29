//
//  AvatarSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 28/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AvatarSceneModel.h"

@implementation AvatarSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self)
    self.request = [UpdateUserRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
}

@end
