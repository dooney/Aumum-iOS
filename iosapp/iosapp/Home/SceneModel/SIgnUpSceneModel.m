//
//  SIgnUpSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 23/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "SignUpSceneModel.h"

@implementation SignUpSceneModel

- (BOOL)isValid {
    return self.username.length > 0 && self.password.length > 0;
}

@end
