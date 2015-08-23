//
//  Country.m
//  iosapp
//
//  Created by Simpson Du on 23/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "Country.h"

@implementation Country

+ (NSString*)getKeys {
    return @"objectId,code,zhName,enName";
}

- (NSString*)getLocaleName {
    return self.zhName;
}

@end
