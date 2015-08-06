//
//  MomentCellSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 2/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentCellSceneModel.h"

@implementation MomentCellSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self)
    self.request = [UpdateMomentRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
}

@end
