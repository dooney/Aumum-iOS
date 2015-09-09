//
//  NewMomentRequest.m
//  iosapp
//
//  Created by Simpson Du on 29/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "NewMomentRequest.h"

@implementation NewMomentRequest

- (void)loadRequest {
    [super loadRequest];
    self.PATH = @"/1/classes/Moments";
    self.METHOD = @"POST";
}

- (void)send:(Moment*)moment {
    self.userId = moment.userId;
    self.imageUrl = moment.imageUrl;
    self.text = moment.text;
    self.ratio = moment.ratio;
    self.tags = moment.tags;
    [self send];
}

@end
