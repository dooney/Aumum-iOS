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

@end

#endif
