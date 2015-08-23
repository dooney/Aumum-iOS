//
//  EditProfileSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 22/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "EditProfileSceneModel.h"

@implementation EditProfileSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self)
    self.request = [UpdateUserRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
}

@end
