//
//  SignInSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_SignInSceneModel_h
#define iosapp_SignInSceneModel_h

#import "SceneModel.h"
#import "LoginRequest.h"

@interface SignInSceneModel : SceneModel

@property (nonatomic, strong)NSString* username;
@property (nonatomic, strong)NSString* password;
@property (nonatomic, strong)LoginRequest* request;

- (BOOL)isValid;

@end

#endif
