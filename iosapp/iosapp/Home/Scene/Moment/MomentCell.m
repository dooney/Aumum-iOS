//
//  MomentCell.m
//  iosapp
//
//  Created by Simpson Du on 3/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentCell.h"
#import "UIView+FLKAutoLayout.h"
#import "UIImageView+Network.h"

@interface MomentCell()

@property (nonatomic, strong)UIImageView* avatarImage;
@property (nonatomic, strong)UILabel* userName;
@property (nonatomic, strong)UILabel* createdAt;
@property (nonatomic, strong)UIImageView* momentImage;

@end

@implementation MomentCell

- (void)commonInit {
    [super commonInit];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.momentImage = [[UIImageView alloc] init];
    self.momentImage.contentMode = UIViewContentModeScaleAspectFill;
    self.momentImage.clipsToBounds = YES;
    [self.contentView addSubview:self.momentImage];
    
    [self loadAutoLayout];
}

- (void)loadAutoLayout {
    [self.momentImage alignToView:self.momentImage.superview];
}

- (void)refresh:(Moment *)moment {
    [self.momentImage net_sd_setImageWithURL:[NSURL URLWithString:moment.imageUrl]];
}

@end
