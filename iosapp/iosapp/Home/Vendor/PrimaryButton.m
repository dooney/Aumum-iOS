//
//  PrimaryButton.m
//  iosapp
//
//  Created by Simpson Du on 25/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "PrimaryButton.h"
#import "UIColor+EasyExtend.h"

@implementation PrimaryButton

- (id)initWithTitle:(NSString*)title {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5;
        self.backgroundColor = HEX_RGB(0xffde00);
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

@end
