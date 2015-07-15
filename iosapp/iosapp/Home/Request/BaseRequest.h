//
//  BaseRequest.h
//  iosapp
//
//  Created by Simpson Du on 1/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_BaseRequest_h
#define iosapp_BaseRequest_h

#import "Request.h"

@interface BaseRequest : Request

- (void)onRequest:(void (^)())successHandler
            error:(void (^)(NSError* error))errorHandler;

@end

#endif
