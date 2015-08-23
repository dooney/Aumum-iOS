//
//  CountryRequest.h
//  iosapp
//
//  Created by Simpson Du on 22/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_CountryRequest_h
#define iosapp_CountryRequest_h

#import "BaseRequest.h"
#import "CountryList.h"

@interface CountryRequest : BaseRequest

@property (nonatomic, strong) CountryList* list;
@property (nonatomic, strong) NSString* keys;

@end

#endif
