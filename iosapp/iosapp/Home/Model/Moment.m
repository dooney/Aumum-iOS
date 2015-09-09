//
//  Moment.m
//  iosapp
//
//  Created by Simpson Du on 1/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "Moment.h"

@implementation Moment

- (id)init:(NSString*)userId
  imageUrl:(NSString*)imageUrl
      text:(NSString*)text
     ratio:(CGFloat)ratio
      tags:(NSMutableArray*)tags {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.imageUrl = imageUrl;
        self.text = text;
        self.ratio = ratio;
        self.tags = tags;
    }
    return self;
}

- (BOOL)isLiked:(NSString*)userId {
    return [self.likes containsObject:userId];
}

- (void)save {
    User* user = self.user;
    self.user = nil;
    [super save];
    self.user = user;
}

@end
