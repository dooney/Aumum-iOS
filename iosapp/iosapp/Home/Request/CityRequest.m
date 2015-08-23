//
//  CityRequest.m
//  iosapp
//
//  Created by Simpson Du on 22/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "CityRequest.h"

@implementation CityRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/classes/City";
    self.METHOD = @"GET";
    self.keys = [City getKeys];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.list = [[CityList alloc] initWithDictionary:self.output error:&error];
    for (City* city in self.list.results) {
        [city insertOrReplace:city.objectId];
    }
    return error;
}

@end
