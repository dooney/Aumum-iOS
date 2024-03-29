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
#import "Profile.h"

@interface LoginRequest : BaseRequest

@property (nonatomic, strong) Profile* profile;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;

- (void)doLogin:(NSString*)username password:(NSString*)password;

@end

#endif
