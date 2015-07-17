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
#import "Conversation.h"
#import "UIView+FLKAutoLayout.h"

@interface ConversationCell()

@property (nonatomic, strong)AvatarImageView* avatarImage;
@property (nonatomic, strong)UILabel* userName;
@property (nonatomic, strong)UILabel* textContent;

@end

@implementation ConversationCell

- (void)commonInit {
    [super commonInit];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.avatarImage = [[AvatarImageView alloc] init];
    [self.contentView addSubview:self.avatarImage];
    
    self.userName = [[UILabel alloc] init];
    [self.contentView addSubview:self.userName];
    
    self.textContent = [[UILabel alloc] init];
    [self.contentView addSubview:self.textContent];
    
    [self loadAutoLayout];
}

- (void)reloadData:(id)entity {
    Conversation* conversation = entity;
    self.userName.text = conversation.user.screenName;
    self.textContent.text = conversation.latestMessage;
    [self.avatarImage fromUrl:conversation.user.avatarUrl diameter:50];
}

- (void)loadAutoLayout {
    [self.avatarImage alignTop:@"10" leading:@"10" toView:self.avatarImage.superview];
    [self.avatarImage alignBottomEdgeWithView:self.avatarImage.superview predicate:@"-10"];
    [self.avatarImage constrainWidth:@"50" height:@"50"];
    
    [self.userName constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.userName alignTopEdgeWithView:self.avatarImage predicate:nil];
    
    [self.textContent constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.textContent alignBottomEdgeWithView:self.avatarImage predicate:nil];
}

@end
