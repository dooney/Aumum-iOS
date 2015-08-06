//
//  UpdateMomentRequest.m
//  iosapp
//
//  Created by Simpson Du on 6/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UpdateMomentRequest.h"

@implementation UpdateMomentRequest

- (void)loadRequest {
    [super loadRequest];
    self.METHOD = @"PUT";
}

- (void)updateLike:(NSString*)op momentId:(NSString*)momentId userId:(NSString*)userId {
    self.PATH = [NSString stringWithFormat:@"/1/classes/Moments/%@", momentId];
    self.likes = @{ @"__op": op, @"objects": @[ userId ] };
    [self send];
}

- (void)addLike:(NSString*)momentId userId:(NSString*)userId {
    [self updateLike:@"AddUnique" momentId:momentId userId:userId];
}

- (void)removeLike:(NSString*)momentId userId:(NSString*)userId {
    [self updateLike:@"Remove" momentId:momentId userId:userId];
}

@end
