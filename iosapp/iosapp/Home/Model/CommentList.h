//
//  CommentList.h
//  iosapp
//
//  Created by Simpson Du on 3/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_CommentList_h
#define iosapp_CommentList_h

#import "Comment.h"
#import "JSONModel.h"

@interface CommentList : JSONModel

@property (nonatomic, strong) NSMutableArray<Comment>* results;

@end

#endif
