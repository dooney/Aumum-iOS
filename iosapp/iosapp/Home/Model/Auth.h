//
//  Auth.h
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Auth_h
#define iosapp_Auth_h

#import "Model.h"

@interface Auth : Model

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* sessionToken;

@end

@protocol Auth

@end

#endif
