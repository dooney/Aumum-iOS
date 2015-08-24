//
//  UserHeader.m
//  iosapp
//
//  Created by Simpson Du on 14/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserHeader.h"
#import "Country.h"
#import "City.h"
#import "ProfileAvatarView.h"
#import "UIColor+EasyExtend.h"
#import "UIView+FLKAutoLayout.h"
#import "UIImageView+WebCache.h"
#import "FXBlurView.h"
#import "IconFont.h"
#import "URLManager.h"
#import <TuSDK/TuSDK.h>

@interface UserHeader()
{
    TuSDKCPAvatarComponent *_avatarComponent;
}

@property (nonatomic, strong) UIImageView* coverImage;
@property (nonatomic, strong) ProfileAvatarView* avatarImage;
@property (nonatomic, strong) UIView* detailsLayout;
@property (nonatomic, strong) UILabel* screenName;
@property (nonatomic, strong) UILabel* regionInfo;
@property (nonatomic, strong) UILabel* about;
@property (nonatomic, strong) UIButton* editButton;
@property (nonatomic, strong) UIButton* cameraButton;

@end

@implementation UserHeader

- (void)reloadUser:(UserDetails*)user {
    if (!self.coverImage) {
        self.coverImage = [[UIImageView alloc] init];
        self.coverImage.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImage.clipsToBounds = YES;
        self.coverImage.backgroundColor = HEX_RGB(0xc5c5c5);
        self.coverImage.userInteractionEnabled = YES;
        [self addSubview:self.coverImage];
        
        [self.coverImage alignToView:self.coverImage.superview];
        [self.coverImage constrainWidth:[NSString stringWithFormat:@"%.f", self.bounds.size.width]
                                 height:[NSString stringWithFormat:@"%.f", self.bounds.size.height]];
    }
    if (!self.detailsLayout) {
        self.detailsLayout = [[UIView alloc] init];
        [self.coverImage addSubview:self.detailsLayout];
        
        [self.detailsLayout alignCenterWithView:self.detailsLayout.superview];
        [self.detailsLayout constrainWidth:@"200" height:@"240"];
    }
    if (!self.avatarImage) {
        self.avatarImage = [[ProfileAvatarView alloc] init];
        self.avatarImage.borderWidth = 3.0f;
        self.avatarImage.diameter = 100;
        self.avatarImage.image = [UIImage imageNamed:@"ic_avatar"];
        [self.detailsLayout addSubview:self.avatarImage];
        
        [self.avatarImage alignTopEdgeWithView:self.avatarImage.superview predicate:@"20"];
        [self.avatarImage alignCenterXWithView:self.avatarImage.superview predicate:@"0"];
        [self.avatarImage constrainWidth:@"100" height:@"100"];
    }
    if (!self.screenName) {
        self.screenName = [[UILabel alloc] init];
        self.screenName.textColor = [UIColor whiteColor];
        self.screenName.font = [UIFont boldSystemFontOfSize:16];
        [self.detailsLayout addSubview:self.screenName];
        
        [self.screenName constrainTopSpaceToView:self.avatarImage predicate:@"10"];
        [self.screenName alignCenterXWithView:self.screenName.superview predicate:@"0"];
    }
    if (!self.regionInfo) {
        self.regionInfo = [IconFont labelWithIcon:nil fontName:ionIcons size:15 color:[UIColor whiteColor]];
        [self.detailsLayout addSubview:self.regionInfo];
        
        [self.regionInfo constrainTopSpaceToView:self.screenName predicate:@"10"];
        [self.regionInfo alignCenterXWithView:self.regionInfo.superview predicate:@"0"];
    }
    if (!self.about) {
        self.about = [[UILabel alloc] init];
        self.about.textColor = [UIColor whiteColor];
        self.about.font = [UIFont systemFontOfSize:14];
        self.about.textAlignment = NSTextAlignmentCenter;
        self.about.numberOfLines = 2;
        [self.detailsLayout addSubview:self.about];
        
        [self.about constrainTopSpaceToView:self.regionInfo predicate:@"10"];
        [self.about alignCenterXWithView:self.about.superview predicate:@"0"];
        [self.about constrainWidth:@"200"];
    }
    if (user) {
        [self.coverImage sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl]
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      [self updateProfileImage:image];
                                  }];
        self.screenName.text = user.screenName;
        Country* country = [Country getById:user.country];
        City* city = [City getById:user.city];
        self.regionInfo.text = [NSString stringWithFormat:@"%@  %@ %@",
                                [IconFont icon:@"ios7NavigateOutline" fromFont:ionIcons],
                                [city getLocaleName],
                                [country getLocaleName]];
        self.about.text = user.about;
    }
}

- (void)reloadProfile:(UserDetails*)user {
    [self reloadUser:user];
    if (user && !self.editButton) {
        self.editButton = [IconFont buttonWithIcon:[IconFont icon:@"edit" fromFont:ionIcons] fontName:ionIcons size:15 color:[UIColor whiteColor]];
        [self.editButton addTarget:self action:@selector(editButtonPressed)forControlEvents:UIControlEventTouchUpInside];
        [self.coverImage addSubview:self.editButton];
        
        [self.editButton alignBottomEdgeWithView:self.screenName predicate:@"4"];
        [self.editButton constrainLeadingSpaceToView:self.screenName predicate:@"0"];
    }
    if (user && !self.cameraButton) {
        self.cameraButton = [IconFont buttonWithIcon:[IconFont icon:@"ios7CameraOutline" fromFont:ionIcons] fontName:ionIcons size:25 color:HEX_RGBA(0xffffff, 0x55)];
        [self.cameraButton addTarget:self action:@selector(cameraButtonPressed)forControlEvents:UIControlEventTouchUpInside];
        [self.coverImage addSubview:self.cameraButton];
        
        [self.cameraButton alignCenterXWithView:self.cameraButton.superview predicate:@"0"];
        [self.cameraButton alignCenterYWithView:self.cameraButton.superview predicate:@"-15"];
    }
}

- (void)editButtonPressed {
    NSString* url = [NSString stringWithFormat:@"iosapp://editProfile"];
    [URLManager pushURLString:url animated:YES];
}

- (void)cameraButtonPressed {
    _avatarComponent = [TuSDK avatarCommponentWithController:self.viewController
                                               callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller) {
                                                   [self updateProfileImage:result.loadResultImage];
                                                   _avatarComponent = nil;
                                                   if (self.delegate) {
                                                       [self.delegate didPressEditButton:result.loadResultImage];
                                                   }
                                               }];
    _avatarComponent.options.editTurnAndCutOptions.saveToAlbum = NO;
    _avatarComponent.autoDismissWhenCompelted = YES;
    [_avatarComponent showComponent];
}

- (void)updateProfileImage:(UIImage*)image {
    self.coverImage.image = [image blurredImageWithRadius:40.0f iterations:2 tintColor:nil];
    self.avatarImage.image = image;
}

@end
