//
//  SignUpSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 23/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_SignUpSceneModel_h
#define iosapp_SignUpSceneModel_h

#import "BaseSceneModel.h"

@interface SignUpSceneModel : BaseSceneModel

@property (nonatomic, strong)NSString* zone;
@property (nonatomic, strong)NSString* username;
@property (nonatomic, strong)NSString* password;

- (BOOL)isValid;

@end

#endif
