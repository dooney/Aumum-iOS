//
//  CountryScene.h
//  iosapp
//
//  Created by Simpson Du on 22/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_CountryScene_h
#define iosapp_CountryScene_h

#import "BaseScene.h"
#import "Country.h"

@protocol CountryDelegate <NSObject>

- (void)getCountry:(Country *)country;

@end

@interface CountryScene : BaseScene

@property (nonatomic, strong)NSObject<CountryDelegate>* delegate;

@end

#endif
