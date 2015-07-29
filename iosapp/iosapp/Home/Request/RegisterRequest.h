//
//  RegisterRequest.h
//  iosapp
//
//  Created by Simpson Du on 28/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_RegisterRequest_h
#define iosapp_RegisterRequest_h

#import "BaseRequest.h"
#import "Profile.h"

@interface RegisterRequest : BaseRequest

@property (nonatomic, strong) Profile* profile;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;

- (void)doRegister:(NSString*)username password:(NSString*)password;

@end

#endif
