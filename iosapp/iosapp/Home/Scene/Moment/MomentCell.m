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
#import "UIColor+EasyExtend.h"

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
    
    self.avatarImage = [[UIImageView alloc] init];
    self.avatarImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.avatarImage];
    
    self.userName = [[UILabel alloc] init];
    self.userName.textAlignment = NSTextAlignmentLeft;
    self.userName.font = [UIFont systemFontOfSize:16.0f];
    self.userName.textColor = HEX_RGB(0xff6060);
    [self.contentView addSubview:self.userName];
    
    self.momentImage = [[UIImageView alloc] init];
    self.momentImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.momentImage];
    
    [self loadAutoLayout];
}

- (void)loadAutoLayout {
    [self.avatarImage alignTop:@"20" leading:@"10" toView:self.userName.superview];
    [self.userName constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.momentImage constrainTopSpaceToView:self.avatarImage predicate:@"20"];
}

- (void)refresh:(Moment *)moment {
    [self.userName setText:moment.user.screenName];
    [self.avatarImage net_sd_setImageWithURL:[NSURL URLWithString:moment.user.avatarUrl]];
    [self.momentImage net_sd_setImageWithURL:[NSURL URLWithString:moment.imageUrl]];
}

@end
