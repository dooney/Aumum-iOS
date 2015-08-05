//
//  CommentCellSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 3/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_CommentCellSceneModel_h
#define iosapp_CommentCellSceneModel_h

#import "BaseSceneModel.h"
#import "Comment.h"

@interface CommentCellSceneModel : BaseSceneModel

@property (nonatomic, strong) Comment* comment;

@end

#endif
