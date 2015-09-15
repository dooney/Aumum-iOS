//
//  AddTagScene.h
//  iosapp
//
//  Created by Simpson Du on 10/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_AddTagScene_h
#define iosapp_AddTagScene_h

#import "BaseScene.h"
#import "IAddTagDelegate.h"

@interface AddTagScene : BaseScene

@property (nonatomic, assign) id <IAddTagDelegate> delegate;

@end

#endif
