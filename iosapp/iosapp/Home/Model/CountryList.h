//
//  CountryList.h
//  iosapp
//
//  Created by Simpson Du on 22/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_CountryList_h
#define iosapp_CountryList_h

#import "Country.h"
#import "JSONModel.h"

@interface CountryList : JSONModel

@property (nonatomic, strong) NSMutableArray<Country>* results;

@end

#endif
