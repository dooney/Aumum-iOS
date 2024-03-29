//
//  VerifySceneModel.m
//  iosapp
//
//  Created by Simpson Du on 25/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "VerifySceneModel.h"

@implementation VerifySceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self)
    self.request = [RegisterRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
}

- (BOOL)isValid {
    return self.code.length == 4;
}

@end
