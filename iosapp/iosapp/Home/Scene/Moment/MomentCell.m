//
//  MomentCell.m
//  iosapp
//
//  Created by Simpson Du on 3/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentCell.h"
#import "Moment.h"
#import "UIView+FLKAutoLayout.h"
#import "UIImageView+WebCache.h"
#import "AvatarImageView.h"
#import "UIColor+EasyExtend.h"
#import "NSDate+Category.h"
#import "URLManager.h"

@interface MomentCell()

@property (nonatomic, strong)Moment* moment;
@property (nonatomic, strong)AvatarImageView* avatarImage;
@property (nonatomic, strong)UILabel* screenName;
@property (nonatomic, strong)UILabel* createdAt;
@property (nonatomic, strong)UIImageView* momentImage;

@end

@implementation MomentCell

- (void)commonInit {
    [super commonInit];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImagePressed)];
    self.avatarImage = [[AvatarImageView alloc] init];
    [self.avatarImage addGestureRecognizer:tap];
    self.avatarImage.userInteractionEnabled = YES;
    self.avatarImage.multipleTouchEnabled = YES;
    [self.contentView addSubview:self.avatarImage];
    
    self.screenName = [[UILabel alloc] init];
    self.screenName.textColor = HEX_RGB(0xff6060);
    [self.contentView addSubview:self.screenName];
    
    self.createdAt = [[UILabel alloc] init];
    self.createdAt.font = [UIFont systemFontOfSize:14];
    self.createdAt.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.createdAt];
    
    self.momentImage = [[UIImageView alloc] init];
    self.momentImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.momentImage];
    
    [self loadAutoLayout];
}

- (void)loadAutoLayout {
    [self.avatarImage alignTop:@"10" leading:@"10" toView:self.avatarImage.superview];
    [self.avatarImage constrainWidth:@"40" height:@"40"];
    
    [self.screenName constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.screenName alignTopEdgeWithView:self.avatarImage predicate:nil];
    
    [self.createdAt alignLeadingEdgeWithView:self.screenName predicate:nil];
    [self.createdAt alignBottomEdgeWithView:self.avatarImage predicate:nil];
    
    [self.momentImage constrainTopSpaceToView:self.avatarImage predicate:@"10"];
    [self.momentImage alignTrailingEdgeWithView:self.momentImage.superview predicate:nil];
    [self.momentImage alignBottomEdgeWithView:self.momentImage.superview predicate:nil];
}

- (void)reloadData:(id)entity {
    self.moment = entity;
    self.screenName.text = self.moment.user.screenName;
    NSDate* createdAt = [NSDate dateWithString:self.moment.createdAt format:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" zone:@"UTC"];
    self.createdAt.text = [createdAt timeIntervalDescription];
    [self.avatarImage fromUrl:self.moment.user.avatarUrl diameter:40];
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat imageHeight = imageWidth * self.moment.ratio;
    [self.momentImage constrainWidth:[NSString stringWithFormat:@"%.2f", imageWidth]
                              height:[NSString stringWithFormat:@"%.2f", imageHeight]];
    [self.momentImage sd_setImageWithURL:[NSURL URLWithString:self.moment.imageUrl]];
}

- (void)avatarImagePressed {
    NSString* url = [NSString stringWithFormat:@"iosapp://user?userId=%@", self.moment.userId];
    [URLManager pushURLString:url animated:YES];
}

@end
