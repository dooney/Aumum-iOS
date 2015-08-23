//
//  CityList.h
//  iosapp
//
//  Created by Simpson Du on 22/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_CityList_h
#define iosapp_CityList_h

#import "City.h"
#import "JSONModel.h"

@interface CityList : JSONModel

@property (nonatomic, strong) NSMutableArray<City>* results;

@end

#endif
