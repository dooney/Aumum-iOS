//
//  Tag.h
//  iosapp
//
//  Created by Simpson Du on 14/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Tag_h
#define iosapp_Tag_h

#import "BaseModel.h"

@interface Tag : BaseModel

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* text;

@end

@protocol Tag

@end

#endif
