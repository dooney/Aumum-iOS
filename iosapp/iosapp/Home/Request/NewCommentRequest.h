//
//  NewCommentRequest.h
//  iosapp
//
//  Created by Simpson Du on 5/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_NewCommentRequest_h
#define iosapp_NewCommentRequest_h

#import "BaseRequest.h"
#import "Comment.h"

@interface NewCommentRequest : BaseRequest

@property (nonatomic, strong)NSString* userId;
@property (nonatomic, strong)NSString* parentId;
@property (nonatomic, strong)NSString* content;

- (void)send:(Comment*)comment;

@end

#endif
