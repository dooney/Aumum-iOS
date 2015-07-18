//
//  SignInSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "SignInSceneModel.h"

@implementation SignInSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self);
    self.request = [LoginRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
}

- (BOOL)isValid {
    return self.username.length > 0 && self.password.length > 0;
}

@end
