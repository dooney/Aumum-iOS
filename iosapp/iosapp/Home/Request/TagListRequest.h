//
//  TagListRequest.h
//  iosapp
//
//  Created by Simpson Du on 14/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_TagListRequest_h
#define iosapp_TagListRequest_h

#import "BaseRequest.h"
#import "TagList.h"

@interface TagListRequest : BaseRequest

@property (nonatomic, strong) TagList* list;
@property (nonatomic, strong) NSString* where;

- (void)getList:(NSArray*)tagList;

@end

#endif
