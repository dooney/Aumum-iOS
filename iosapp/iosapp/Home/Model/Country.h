//
//  Country.h
//  iosapp
//
//  Created by Simpson Du on 23/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Country_h
#define iosapp_Country_h

#import "BaseModel.h"

@interface Country : BaseModel

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* code;
@property (nonatomic, strong)NSString* zhName;
@property (nonatomic, strong)NSString* enName;

+ (NSString*)getKeys;
- (NSString*)getLocaleName;

@end

@protocol Country

@end

#endif
