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
#import "URLManager.h"

@interface MomentCell()

@property (nonatomic, strong)Moment* moment;
@property (nonatomic, strong)AvatarImageView* avatarImage;
@property (nonatomic, strong)UILabel* userName;
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
    
    self.userName = [[UILabel alloc] init];
    [self.contentView addSubview:self.userName];
    
    self.momentImage = [[UIImageView alloc] init];
    self.momentImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.momentImage];
    
    [self loadAutoLayout];
}

- (void)loadAutoLayout {
    [self.avatarImage alignTop:@"10" leading:@"10" toView:self.avatarImage.superview];
    [self.avatarImage constrainWidth:@"40" height:@"40"];
    
    [self.userName constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.userName alignTopEdgeWithView:self.avatarImage predicate:nil];
    
    [self.momentImage constrainTopSpaceToView:self.avatarImage predicate:@"10"];
    [self.momentImage alignTrailingEdgeWithView:self.momentImage.superview predicate:nil];
    [self.momentImage alignBottomEdgeWithView:self.momentImage.superview predicate:nil];
}

- (void)reloadData:(id)entity {
    self.moment = entity;
    self.userName.text = self.moment.user.screenName;
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
