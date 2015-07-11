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
#import "Auth.h"

@interface SignInSceneModel : SceneModel

@property (nonatomic, strong)LoginRequest* request;
@property (nonatomic, strong)Auth* auth;

- (void)onRequest:(void (^)(Auth* auth))successHandler
            error:(void (^)(NSError* error))errorHandler;

@end

#endif
