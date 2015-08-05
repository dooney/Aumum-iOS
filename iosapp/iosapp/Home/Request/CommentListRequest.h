//
//  CommentListRequest.h
//  iosapp
//
//  Created by Simpson Du on 3/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_CommentListRequest_h
#define iosapp_CommentListRequest_h

#import "BaseRequest.h"
#import "CommentList.h"

@interface CommentListRequest : BaseRequest

@property (nonatomic, strong) CommentList* list;
@property (nonatomic, strong) NSString* order;
@property (nonatomic, strong) NSString* where;
@property (nonatomic, strong) NSString* limit;
@property (nonatomic, strong) NSNumber* isEnd;

- (void)send:(NSString*)momentId;

@end

#endif
