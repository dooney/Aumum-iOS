//
//  NewMomentScene.h
//  iosapp
//
//  Created by Simpson Du on 31/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_NewMomentScene_h
#define iosapp_NewMomentScene_h

#import "BaseScene.h"

@interface NewMomentScene : BaseScene

- (id)initWithImage:(UIImage*)image
            preview:(UIImage*)preview
            tagList:(NSMutableArray*)tagList;

@end

#endif
