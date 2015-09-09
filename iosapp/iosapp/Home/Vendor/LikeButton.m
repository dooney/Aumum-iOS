//
//  LikeButton.m
//  iosapp
//
//  Created by Simpson Du on 5/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "LikeButton.h"
#import "UIColor+EasyExtend.h"
#import "IconFont.h"

@implementation LikeButton

- (void)setLike:(BOOL)like {
    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    [self.layer addAnimation:scaleAnimation forKey:nil];
    [self setIcon:like];
}

- (void)setIcon:(BOOL)like {
    NSString* title = [NSString stringWithFormat:@"%@  %@", [IconFont icon:@"ios7Heart" fromFont:ionIcons], NSLocalizedString(@"label.like", nil)];
    if (like) {
        [IconFont button:self fontName:ionIcons setIcon:title size:15 color:HEX_RGB(0xff6060)];
    } else {
        [IconFont button:self fontName:ionIcons setIcon:title size:15 color:[UIColor lightGrayColor]];
    }
}

@end
