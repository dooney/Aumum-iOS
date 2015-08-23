//
//  ContextSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 5/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ContextSceneModel_h
#define iosapp_ContextSceneModel_h

#import "BaseSceneModel.h"
#import "ProfileRequest.h"
#import "CountryRequest.h"
#import "CityRequest.h"

@interface ContextSceneModel : BaseSceneModel

@property (nonatomic, strong)ProfileRequest* profileRequest;
@property (nonatomic, strong)CountryRequest* countryRequest;
@property (nonatomic, strong)CityRequest* cityRequest;

@end

#endif
