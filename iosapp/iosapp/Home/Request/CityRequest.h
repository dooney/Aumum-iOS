//
//  CityRequest.h
//  iosapp
//
//  Created by Simpson Du on 22/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_CityRequest_h
#define iosapp_CityRequest_h

#import "BaseRequest.h"
#import "CityList.h"

@interface CityRequest : BaseRequest

@property (nonatomic, strong) CityList* list;
@property (nonatomic, strong) NSString* keys;

@end

#endif
