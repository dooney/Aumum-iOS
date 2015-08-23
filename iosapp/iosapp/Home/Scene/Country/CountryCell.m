//
//  CountryCell.m
//  iosapp
//
//  Created by Simpson Du on 23/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "CountryCell.h"
#import "Country.h"
#import "UIView+FLKAutoLayout.h"

@interface CountryCell()

@property (nonatomic, strong)UILabel* content;

@end

@implementation CountryCell

- (void)commonInit {
    [super commonInit];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.content = [[UILabel alloc] init];
    [self.contentView addSubview:self.content];
    
    [self loadAutoLayout];
}

- (void)loadAutoLayout {
    [self.content alignLeadingEdgeWithView:self.content.superview predicate:@"15"];
    [self.content alignCenterYWithView:self.content.superview predicate:nil];
}

- (void)reloadData:(id)entity {
    Country* country = entity;
    self.content.text = [NSString stringWithFormat:@"%@ %@", [country getLocaleName], country.code];
}

@end
