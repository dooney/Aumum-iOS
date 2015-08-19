//
//  BaseScene.h
//  iosapp
//
//  Created by Simpson Du on 20/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_BaseScene_h
#define iosapp_BaseScene_h

#import "Scene.h"

@interface BaseScene : Scene

- (void)showError:(NSError*)error;
- (void)showSuccess:(NSString*)title message:(NSString*)message;

@end

#endif
