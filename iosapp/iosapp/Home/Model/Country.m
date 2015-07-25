//
//  Country.m
//  iosapp
//
//  Created by Simpson Du on 23/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "Country.h"

@implementation Country

- (id)initWithName:(NSString*)name code:(NSString*)code {
    self = [super init];
    if (self) {
        self.name = name;
        self.code = code;
    }
    return self;
}

@end
