//
//  PhotoCell.m
//  iosapp
//
//  Created by Simpson Du on 12/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "PhotoCell.h"
#import "UIView+FLKAutoLayout.h"
#import "UIImageView+WebCache.h"

@interface PhotoCell()

@property (nonatomic, strong) UIImageView* image;

@end

@implementation PhotoCell

- (void)reloadData:(NSString*)imageUrl {
    if (!self.image) {
        self.image = [[UIImageView alloc] init];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.image];
        [self.image alignToView:self.image.superview];
    }
    [self.image sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
