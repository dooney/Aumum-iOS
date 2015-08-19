//
//  ConversationCell.m
//  iosapp
//
//  Created by Simpson Du on 14/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ConversationCell.h"
#import "AvatarImageView.h"
#import "UIColor+EasyExtend.h"
#import "UIView+FLKAutoLayout.h"
#import "NSDate+Category.h"
#import "RKNotificationHub.h"
#import "Conversation.h"

@interface ConversationCell()

@property (nonatomic, strong) AvatarImageView* avatarImage;
@property (nonatomic, strong) UILabel* screenName;
@property (nonatomic, strong) UILabel* createdAt;
@property (nonatomic, strong) UILabel* content;
@property (nonatomic, strong) RKNotificationHub* hub;

@end

@implementation ConversationCell

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
    
    self.hub = [[RKNotificationHub alloc] initWithView:self.avatarImage];
    [self.hub setCircleAtFrame:CGRectMake(35, -5, 20, 20)];
    
    self.screenName = [[UILabel alloc] init];
    self.screenName.textColor = HEX_RGB(0xff6060);
    [self.contentView addSubview:self.screenName];
    
    self.createdAt = [[UILabel alloc] init];
    self.createdAt.font = [UIFont systemFontOfSize:12];
    self.createdAt.textColor = [UIColor lightGrayColor];
    self.createdAt.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.createdAt];
    
    self.content = [[UILabel alloc] init];
    [self.contentView addSubview:self.content];
}

- (void)loadAutoLayout {
    [self.avatarImage alignTop:@"10" leading:@"10" toView:self.avatarImage.superview];
    [self.avatarImage alignBottomEdgeWithView:self.avatarImage.superview predicate:@"-10"];
    [self.avatarImage constrainWidth:@"50" height:@"50"];
    
    [self.screenName constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.screenName alignTopEdgeWithView:self.avatarImage predicate:nil];
    [self.screenName alignTrailingEdgeWithView:self.screenName.superview predicate:@"-80"];
    
    [self.createdAt constrainLeadingSpaceToView:self.screenName predicate:@"0"];
    [self.createdAt alignTopEdgeWithView:self.screenName predicate:nil];
    [self.createdAt alignTrailingEdgeWithView:self.createdAt.superview predicate:@"-10"];
    
    [self.content alignLeadingEdgeWithView:self.screenName predicate:nil];
    [self.content constrainTopSpaceToView:self.screenName predicate:@"5"];
    [self.content alignTrailingEdgeWithView:self.content.superview predicate:@"-10"];
    [self.content alignBottomEdgeWithView:self.content.superview predicate:@"-5"];
}

- (void)reloadData:(id)entity {
    Conversation* conversation = entity;
    self.screenName.text = conversation.user.screenName;
    self.content.text = conversation.latestMessage;
    self.createdAt.text = [[NSDate dateWithTimeIntervalSince1970:conversation.latestTimestamp / 1000] timeIntervalDescription];
    [self.avatarImage fromUrl:conversation.user.avatarUrl diameter:50];
    self.hub.count = conversation.unreadCount;
}

@end
