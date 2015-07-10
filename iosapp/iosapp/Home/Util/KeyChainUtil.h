//
//  KeyChainUtil.h
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_KeyChainUtil_h
#define iosapp_KeyChainUtil_h

#import <Foundation/Foundation.h>

@interface KeyChainUtil : NSObject 

+ (NSString*)getToken;
+ (void)setToken:(NSString*)token;

+ (NSString*)getCurrentUserId;
+ (void)setCurrentUserId:(NSString*)userId;

@end

#endif
