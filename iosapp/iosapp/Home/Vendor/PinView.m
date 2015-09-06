//
//  PinView.m
//  iosapp
//
//  Created by Simpson Du on 6/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "PinView.h"
#import <PulsingHaloLayer.h>
#import "UIView+FLKAutoLayout.h"

@interface PinView()

@property (nonatomic, strong) UIImageView* background;
@property (nonatomic, strong) PulsingHaloLayer* halo;

@end

@implementation PinView

- (id)init {
    self = [super init];
    if (self) {
        PulsingHaloLayer *layer = [PulsingHaloLayer layer];
        self.halo = layer;
        self.halo.radius = 15;
        self.halo.backgroundColor = [UIColor blackColor].CGColor;
        
        self.background = [[UIImageView alloc] init];
        self.background.contentMode = UIViewContentModeScaleAspectFit;
        self.background.image = [UIImage imageNamed:@"brand_tag_point_white_bg"];
        
        [self addSubview:self.background];
        [self.background alignToView:self];
        
        [self constrainWidth:@"18" height:@"18"];
        self.halo.position = CGPointMake(9, 9);
        [self.layer insertSublayer:self.halo below:self.background.layer];
    }
    return self;
}

@end
