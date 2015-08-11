//
//  MomentNotificationCell.m
//  iosapp
//
//  Created by Simpson Du on 9/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentNotificationCell.h"
#import "UIView+FLKAutoLayout.h"
#import "Notification.h"
#import "UIImageView+WebCache.h"

@interface MomentNotificationCell()

@property (nonatomic, strong) UIImageView* momentImage;

@end

@implementation MomentNotificationCell

- (void)initRightLayout:(UIView *)rightLayout {
    [super initRightLayout:rightLayout];
    
    self.momentImage = [[UIImageView alloc] init];
    self.momentImage.contentMode = UIViewContentModeScaleAspectFit;
    [rightLayout addSubview:self.momentImage];
    
    [self.momentImage constrainWidth:@"80" height:@"80"];
    [self.momentImage alignCenterWithView:self.momentImage.superview];
}

- (void)reloadData:(id)entity {
    [super reloadData:entity];
    
    Notification* notification = entity;
    [self.momentImage sd_setImageWithURL:[NSURL URLWithString:notification.imageUrl]];
}

@end
