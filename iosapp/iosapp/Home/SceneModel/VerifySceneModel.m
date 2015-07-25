//
//  VerifySceneModel.m
//  iosapp
//
//  Created by Simpson Du on 25/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "VerifySceneModel.h"

@implementation VerifySceneModel

- (BOOL)isValid {
    return self.code.length == 4;
}

@end
