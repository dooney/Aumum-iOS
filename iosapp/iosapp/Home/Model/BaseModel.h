//
//  BaseModel.h
//  iosapp
//
//  Created by Simpson Du on 15/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_BaseModel_h
#define iosapp_BaseModel_h

#import "Model.h"

@interface BaseModel : Model

- (void)insertOrReplace:(NSString*)objectId;
+ (id)getById:(NSString*)objectId;

@end

#endif
