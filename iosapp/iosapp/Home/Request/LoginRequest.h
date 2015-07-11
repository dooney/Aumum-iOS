//
//  LoginRequest.h
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_LoginRequest_h
#define iosapp_LoginRequest_h

#import "BaseRequest.h"

@interface LoginRequest : BaseRequest

- (void)setAuthInfo:(NSString*)userName password:(NSString*)password;

@end

#endif