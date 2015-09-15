//
//  BatchRequest.h
//  iosapp
//
//  Created by Simpson Du on 14/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_BatchRequest_h
#define iosapp_BatchRequest_h

#import "BaseRequest.h"

@interface BatchRequest : BaseRequest

@property (nonatomic, strong) NSMutableArray* requests;

@end

#endif
