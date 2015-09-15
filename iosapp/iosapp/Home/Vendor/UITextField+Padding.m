//
//  UITextField+Padding.m
//  iosapp
//
//  Created by Simpson Du on 13/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UITextField+Padding.h"

@implementation UITextField (Padding)

static CGFloat leftMargin = 10;

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += leftMargin;
    
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds.origin.x += leftMargin;
    
    return bounds;
}

@end
