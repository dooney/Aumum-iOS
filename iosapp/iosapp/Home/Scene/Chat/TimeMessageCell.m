//
//  TimeMessageCell.m
//  iosapp
//
//  Created by Simpson Du on 13/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "TimeMessageCell.h"
#import "UIColor+EasyExtend.h"
#import "Constants.h"
#import "UIView+FLKAutoLayout.h"

@interface TimeMessageCell()

@property (nonatomic, strong)UILabel* textContent;

@end

@implementation TimeMessageCell

- (void)commonInit {
    [super commonInit];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textContent = [[UILabel alloc] init];
    self.textContent.textAlignment = NSTextAlignmentCenter;
    self.textContent.font = [UIFont systemFontOfSize:TX_SZ_SMALL];
    self.textContent.textColor = HEX_RGB(AM_GREY);
    [self.contentView addSubview:self.textContent];
    
    [self loadAutoLayout];
}

- (void)reloadData:(id)entity {
    self.textContent.text = (NSString *)entity;
}

- (void)loadAutoLayout {
    [self.textContent alignToView:self.textContent.superview];
}

@end
