//
//  MomentCell.m
//  iosapp
//
//  Created by Simpson Du on 3/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentCell.h"
#import "UIView+FLKAutoLayout.h"
#import "UIColor+EasyExtend.h"
#import "UIImageView+WebCache.h"
#import "NZCircularImageView.h"

@interface MomentCell()

@property (nonatomic, strong)NZCircularImageView* avatarImage;
@property (nonatomic, strong)UILabel* userName;
@property (nonatomic, strong)UILabel* createdAt;
@property (nonatomic, strong)UIImageView* momentImage;

@end

@implementation MomentCell

- (void)commonInit {
    [super commonInit];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.avatarImage = [[NZCircularImageView alloc] init];
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
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat imageHeight = imageWidth;
    [self.momentImage alignTop:@"60" bottom:@"-60" toView:self.momentImage.superview];
    [self.momentImage constrainWidth:[NSString stringWithFormat:@"%.2f", imageWidth]
                              height:[NSString stringWithFormat:@"%.2f", imageHeight]];
    
    [self.avatarImage alignTop:@"10" leading:@"10" toView:self.avatarImage.superview];
    [self.avatarImage constrainWidth:@"40" height:@"40"];
    
    [self.userName constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.userName alignTopEdgeWithView:self.avatarImage predicate:nil];
}

- (void)reload:(Moment *)moment {
    self.userName.text = moment.user.screenName;
    [self.avatarImage setImageWithResizeURL:moment.user.avatarUrl];
    [self.momentImage sd_setImageWithURL:[NSURL URLWithString:moment.imageUrl]];
}

@end
