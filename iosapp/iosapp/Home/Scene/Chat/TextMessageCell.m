//
//  TextMessageCell.m
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "TextMessageCell.h"
#import "NZCircularImageView.h"
#import "UIColor+EasyExtend.h"
#import "Constants.h"
#import "ChatMessage.h"
#import "UIView+FLKAutoLayout.h"

@interface TextMessageCell()

@property (nonatomic, strong)NZCircularImageView* avatarImage;
@property (nonatomic, strong)UILabel* textContent;

@end

@implementation TextMessageCell

- (void)commonInit {
    [super commonInit];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.avatarImage = [[NZCircularImageView alloc] init];
    [self.contentView addSubview:self.avatarImage];
    
    self.textContent = [[UILabel alloc] init];
    self.textContent.textAlignment = NSTextAlignmentLeft;
    self.textContent.font = [UIFont systemFontOfSize:TX_SZ_MEDIUM];
    self.textContent.textColor = HEX_RGB(AM_RED);
    [self.contentView addSubview:self.textContent];
    
    [self loadAutoLayout];
}

- (void)reloadData:(id)entity {
    ChatMessage* message = entity;
    self.textContent.text = message.textContent;
    [self.avatarImage setImageWithResizeURL:message.user.avatarUrl];
}

- (void)loadAutoLayout {
    [self.avatarImage alignTop:@"10" leading:@"10" toView:self.avatarImage.superview];
    [self.avatarImage alignBottomEdgeWithView:self.avatarImage.superview predicate:@"10"];
    [self.avatarImage constrainWidth:@"40" height:@"40"];
    
    [self.textContent constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.textContent alignTopEdgeWithView:self.avatarImage predicate:@"10"];
    [self.textContent constrainWidth:@"200"];
}

@end
