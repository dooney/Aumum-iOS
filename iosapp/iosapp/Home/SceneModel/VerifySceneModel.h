//
//  VerifySceneModel.h
//  iosapp
//
//  Created by Simpson Du on 25/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_VerifySceneModel_h
#define iosapp_VerifySceneModel_h

#import "BaseSceneModel.h"
#import "RegisterRequest.h"

@interface VerifySceneModel : BaseSceneModel

@property (nonatomic, strong)NSString* username;
@property (nonatomic, strong)NSString* zone;
@property (nonatomic, strong)NSString* password;
@property (nonatomic, strong)NSString* code;
@property (nonatomic, assign)BOOL enableResend;
@property (nonatomic, strong)RegisterRequest* request;

- (BOOL)isValid;

@end

#endif
