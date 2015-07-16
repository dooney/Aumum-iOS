//
//  BaseModel.m
//  iosapp
//
//  Created by Simpson Du on 15/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)insertOrReplace:(NSString*)objectId {
    BaseModel* entity = [[self class] getById:objectId];
    if (entity) {
        [entity delete];
    }
    [self save];
}

+ (id)getById:(NSString*)objectId {
    return [[[self class] findByColumn:@"objectId" value:objectId] firstObject];
}

@end
