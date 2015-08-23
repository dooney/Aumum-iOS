//
//  City.h
//  iosapp
//
//  Created by Simpson Du on 22/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_City_h
#define iosapp_City_h

#import "BaseModel.h"

@interface City : BaseModel

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* country;
@property (nonatomic, strong)NSString* zhName;
@property (nonatomic, strong)NSString* enName;

+ (NSString*)getKeys;
- (NSString*)getLocaleName;

@end

@protocol City

@end

#endif
