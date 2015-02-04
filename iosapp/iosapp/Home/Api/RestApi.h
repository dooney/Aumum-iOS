//
//  RestApi.h
//  iosapp
//
//  Created by Simpson Du on 3/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestApi : NSObject

+(void) getPartyList:(void (^)(NSDictionary* data))finishHandler
               error:(void (^)(NSString* error))errorHandler;

@end
