//
//  Profile.m
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "Profile.h"
#import "KeyChainUtil.h"

@implementation Profile

+ (id)get {
    NSString* currentUserId = [KeyChainUtil getCurrentUserId];
    return [[self findByColumn:@"objectId" value:currentUserId] firstObject];
}

@end
