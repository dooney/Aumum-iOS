//
//  CountryRequest.m
//  iosapp
//
//  Created by Simpson Du on 22/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "CountryRequest.h"

@implementation CountryRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/classes/Country";
    self.METHOD = @"GET";
    self.keys = [Country getKeys];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    NSError* error;
    self.list = [[CountryList alloc] initWithDictionary:self.output error:&error];
    for (Country* country in self.list.results) {
        [country insertOrReplace:country.objectId];
    }
    return error;
}

@end
