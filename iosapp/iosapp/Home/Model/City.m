//
//  City.m
//  iosapp
//
//  Created by Simpson Du on 22/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "City.h"

@implementation City

+ (NSString*)getKeys {
    return @"objectId,country,zhName,enName";
}

- (NSString*)getLocaleName {
    return self.zhName;
}

@end
