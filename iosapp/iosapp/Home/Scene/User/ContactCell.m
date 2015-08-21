//
//  ContactCell.m
//  iosapp
//
//  Created by Simpson Du on 20/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ContactCell.h"
#import "AvatarImageView.h"
#import "UIView+FLKAutoLayout.h"
#import "User.h"

@interface ContactCell()

@property (nonatomic, strong) AvatarImageView* avatarImage;
@property (nonatomic, strong) UILabel* screenName;

@end

@implementation ContactCell

- (void)commonInit {
    [super commonInit];
    
    [self initView];
    [self addControls];
    [self loadAutoLayout];
}

- (void)initView {
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)addControls {
    self.avatarImage = [[AvatarImageView alloc] init];
    [self.contentView addSubview:self.avatarImage];
    
    self.screenName = [[UILabel alloc] init];
    [self.contentView addSubview:self.screenName];
}

- (void)loadAutoLayout {
    [self.avatarImage alignCenterYWithView:self.avatarImage.superview predicate:@"0"];
    [self.avatarImage alignLeadingEdgeWithView:self.avatarImage.superview predicate:@"10"];
    [self.avatarImage constrainWidth:@"40" height:@"40"];
    
    [self.screenName alignCenterYWithView:self.screenName.superview predicate:@"0"];
    [self.screenName constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.screenName alignTrailingEdgeWithView:self.screenName.superview predicate:@"-10"];
}

- (void)reloadData:(id)entity {
    User* user = (User*)entity;
    [self.avatarImage fromUrl:user.avatarUrl diameter:40];
    self.screenName.text = user.screenName;
}

@end
