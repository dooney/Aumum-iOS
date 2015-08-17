//
//  MomentListRequest.h
//  iosapp
//
//  Created by Simpson Du on 1/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_MomentListRequest_h
#define iosapp_MomentListRequest_h

#import "BaseRequest.h"
#import "MomentList.h"

@interface MomentListRequest : BaseRequest

@property (nonatomic, strong) MomentList* list;
@property (nonatomic, strong) NSString* order;
@property (nonatomic, strong) NSString* where;
@property (nonatomic, strong) NSString* limit;
@property (nonatomic, strong) NSNumber* isEnd;

- (void)getList:(NSString*)before after:(NSString*)after;
- (void)getListByUserId:(NSString*)userId before:(NSString*)before;

@end

#endif
