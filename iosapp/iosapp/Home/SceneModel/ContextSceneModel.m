//
//  ContextSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 5/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ContextSceneModel.h"

@implementation ContextSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self)
    self.profileRequest = [ProfileRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_NO_CACHE_ACTION:self.profileRequest];
    }];
    self.countryRequest = [CountryRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_NO_CACHE_ACTION:self.countryRequest];
    }];
    self.cityRequest = [CityRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_NO_CACHE_ACTION:self.cityRequest];
    }];
}

@end
