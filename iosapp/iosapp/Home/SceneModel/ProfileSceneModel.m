//
//  ProfileSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 15/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ProfileSceneModel.h"

@implementation ProfileSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self)
    self.request = [ProfileRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
}

@end
