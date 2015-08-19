//
//  UserHeader.m
//  iosapp
//
//  Created by Simpson Du on 14/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserHeader.h"
#import "UserDetails.h"
#import "ProfileAvatarView.h"
#import "UIColor+EasyExtend.h"
#import "UIView+FLKAutoLayout.h"
#import "UIImageView+WebCache.h"
#import "FXBlurView.h"
#import "IconFont.h"

@interface UserHeader()

@property (nonatomic, strong) UIImageView* coverImage;
@property (nonatomic, strong) ProfileAvatarView* avatarImage;
@property (nonatomic, strong) UIView* detailsLayout;
@property (nonatomic, strong) UILabel* screenName;
@property (nonatomic, strong) UILabel* regionInfo;

@end

@implementation UserHeader

- (void)reloadData:(id)entity {
    if (!self.coverImage) {
        self.coverImage = [[UIImageView alloc] init];
        self.coverImage.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImage.clipsToBounds = YES;
        self.coverImage.backgroundColor = HEX_RGB(0xc5c5c5);
        [self addSubview:self.coverImage];
        
        [self.coverImage alignToView:self.coverImage.superview];
        [self.coverImage constrainWidth:[NSString stringWithFormat:@"%.f", self.bounds.size.width]
                                 height:[NSString stringWithFormat:@"%.f", self.bounds.size.height]];
    }
    if (!self.detailsLayout) {
        self.detailsLayout = [[UIView alloc] init];
        [self.coverImage addSubview:self.detailsLayout];
        
        [self.detailsLayout alignCenterWithView:self.detailsLayout.superview];
        [self.detailsLayout constrainWidth:@"200" height:@"200"];
    }
    if (!self.avatarImage) {
        self.avatarImage = [[ProfileAvatarView alloc] init];
        self.avatarImage.borderWidth = 3.0f;
        self.avatarImage.diameter = 80;
        self.avatarImage.image = [UIImage imageNamed:@"ic_avatar"];
        [self.detailsLayout addSubview:self.avatarImage];
        
        [self.avatarImage alignTopEdgeWithView:self.avatarImage.superview predicate:@"30"];
        [self.avatarImage alignCenterXWithView:self.avatarImage.superview predicate:@"0"];
        [self.avatarImage constrainWidth:@"80" height:@"80"];
    }
    if (!self.screenName) {
        self.screenName = [[UILabel alloc] init];
        self.screenName.textColor = [UIColor whiteColor];
        self.screenName.font = [UIFont boldSystemFontOfSize:16];
        [self.detailsLayout addSubview:self.screenName];
        
        [self.screenName constrainTopSpaceToView:self.avatarImage predicate:@"10"];
        [self.screenName alignCenterXWithView:self.screenName.superview predicate:@"0"];
    }
    UserDetails* user = (UserDetails*)entity;
    if (user) {
        [self.coverImage sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl]
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      self.coverImage.image = [image blurredImageWithRadius:40.0f iterations:2 tintColor:nil];
                                      self.avatarImage.image = image;
                                  }];
        self.screenName.text = user.screenName;
        if (!self.regionInfo) {
            NSString* title = [NSString stringWithFormat:@"%@  %@ %@", [IconFont icon:@"ios7NavigateOutline" fromFont:ionIcons], user.city, user.country];
            self.regionInfo = [IconFont labelWithIcon:title fontName:ionIcons size:15 color:[UIColor whiteColor]];
            [self.detailsLayout addSubview:self.regionInfo];
            
            [self.regionInfo constrainTopSpaceToView:self.screenName predicate:@"5"];
            [self.regionInfo alignCenterXWithView:self.regionInfo.superview predicate:@"0"];
        }
    }
}

@end
