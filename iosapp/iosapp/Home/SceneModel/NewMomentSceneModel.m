//
//  NewMomentSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 31/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "NewMomentSceneModel.h"

@implementation NewMomentSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self)
    self.request = [NewMomentRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
}

@end
