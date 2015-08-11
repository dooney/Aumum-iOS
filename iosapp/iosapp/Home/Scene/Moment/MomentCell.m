//
//  MomentCell.m
//  iosapp
//
//  Created by Simpson Du on 3/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentCell.h"
#import "UIView+FLKAutoLayout.h"
#import "UIImageView+WebCache.h"
#import "AvatarImageView.h"
#import "LikeButton.h"
#import "UIColor+EasyExtend.h"
#import "NSDate+Category.h"
#import "URLManager.h"
#import "IconFont.h"
#import "MomentCellSceneModel.h"
#import "KeyChainUtil.h"

@interface MomentCell()

@property (nonatomic, strong)MomentCellSceneModel* sceneModel;
@property (nonatomic, strong)UIView* headerLayout;
@property (nonatomic, strong)AvatarImageView* avatarImage;
@property (nonatomic, strong)UILabel* screenName;
@property (nonatomic, strong)UILabel* createdAt;
@property (nonatomic, strong)UIImageView* momentImage;
@property (nonatomic, strong)LikeButton* likeButton;
@property (nonatomic, strong)UIButton* commentButton;
@property (nonatomic, strong)UIButton* shareButton;
@property (nonatomic, strong)UIView* footerlayout;
@property (nonatomic, strong)NSLayoutConstraint* momentImageHeightConstraint;

@end

@implementation MomentCell

- (void)commonInit {
    [super commonInit];
    
    [self initView];
    [self addControls];
    [self loadAutoLayout];
    [self initSceneModel];
}

- (void)initView {
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)addControls {
    self.headerLayout = [[UIView alloc] init];
    self.headerLayout.backgroundColor = [UIColor whiteColor];
    self.headerLayout.layer.cornerRadius = 3;
    self.headerLayout.layer.borderColor = [UIColor grayColor].CGColor;
    self.headerLayout.layer.borderWidth = 0.3;
    [self.contentView addSubview:self.headerLayout];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImagePressed)];
    self.avatarImage = [[AvatarImageView alloc] init];
    [self.avatarImage addGestureRecognizer:tap];
    self.avatarImage.userInteractionEnabled = YES;
    self.avatarImage.multipleTouchEnabled = YES;
    [self.headerLayout addSubview:self.avatarImage];
    
    self.screenName = [[UILabel alloc] init];
    self.screenName.textColor = HEX_RGB(0xff6060);
    [self.headerLayout addSubview:self.screenName];
    
    self.createdAt = [[UILabel alloc] init];
    self.createdAt.font = [UIFont systemFontOfSize:14];
    self.createdAt.textColor = [UIColor lightGrayColor];
    [self.headerLayout addSubview:self.createdAt];
    
    self.footerlayout = [[UIView alloc] init];
    self.footerlayout.backgroundColor = [UIColor whiteColor];
    self.footerlayout.layer.cornerRadius = 3;
    self.footerlayout.layer.borderColor = [UIColor grayColor].CGColor;
    self.footerlayout.layer.borderWidth = 0.3;
    [self.contentView addSubview:self.footerlayout];
    
    self.likeButton = [[LikeButton alloc] init];
    [self.likeButton addTarget:self action:@selector(likeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.footerlayout addSubview:self.likeButton];
    
    NSString* commentTitle = [NSString stringWithFormat:@"%@  %@", [IconFont icon:@"ios7Chatboxes" fromFont:ionIcons], NSLocalizedString(@"label.comment", nil)];
    self.commentButton = [IconFont buttonWithIcon:commentTitle fontName:ionIcons size:15 color:[UIColor lightGrayColor]];
    [self.commentButton addTarget:self action:@selector(commentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.footerlayout addSubview:self.commentButton];
    
    NSString* shareTitle = [NSString stringWithFormat:@"%@  %@", [IconFont icon:@"ios7Redo" fromFont:ionIcons], NSLocalizedString(@"label.share", nil)];
    self.shareButton = [IconFont buttonWithIcon:shareTitle fontName:ionIcons size:15 color:[UIColor lightGrayColor]];
    [self.shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.footerlayout addSubview:self.shareButton];
    
    self.momentImage = [[UIImageView alloc] init];
    self.momentImage.contentMode = UIViewContentModeScaleAspectFit;
    self.momentImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.momentImage.layer.shadowOffset = CGSizeZero;
    self.momentImage.layer.shadowRadius = 3;
    self.momentImage.layer.shadowOpacity = 0.3;
    [self.contentView addSubview:self.momentImage];
}

- (void)loadAutoLayout {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    [self.headerLayout alignTop:@"10" leading:@"10" toView:self.headerLayout.superview];
    [self.headerLayout constrainWidth:[NSString stringWithFormat:@"%.0f", width - 20] height:@"65"];
    
    [self.avatarImage alignTop:@"10" leading:@"10" toView:self.avatarImage.superview];
    [self.avatarImage constrainWidth:@"40" height:@"40"];
    
    [self.screenName constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.screenName alignTopEdgeWithView:self.avatarImage predicate:nil];
    
    [self.createdAt alignLeadingEdgeWithView:self.screenName predicate:nil];
    [self.createdAt alignBottomEdgeWithView:self.avatarImage predicate:nil];
    
    [self.momentImage constrainTopSpaceToView:self.headerLayout predicate:@"-5"];
    [self.momentImage alignCenterXWithView:self.momentImage.superview predicate:@"0"];
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width;
    [self.momentImage constrainWidth:[NSString stringWithFormat:@"%.0f", imageWidth]];
    
    [self.footerlayout alignCenterXWithView:self.footerlayout.superview predicate:@"0"];
    [self.footerlayout alignBottomEdgeWithView:self.footerlayout.superview predicate:@"0"];
    [self.footerlayout constrainWidth:[NSString stringWithFormat:@"%.0f", imageWidth - 20] height:@"40"];
    
    [self.likeButton alignTop:@"10" leading:@"15" toView:self.likeButton.superview];
    [self.commentButton alignCenterXWithView:self.commentButton.superview predicate:@"0"];
    [self.shareButton alignTrailingEdgeWithView:self.shareButton.superview predicate:@"-15"];
    NSArray* layouts = @[ self.likeButton, self.commentButton, self.shareButton ];
    [UIView alignTopEdgesOfViews:layouts];
}

- (void)initSceneModel {
    self.sceneModel = [MomentCellSceneModel SceneModel];
    self.sceneModel.userId = [KeyChainUtil getCurrentUserId];
}

- (void)reloadData:(id)entity {
    self.sceneModel.moment = entity;
    self.screenName.text = self.sceneModel.moment.user.screenName;
    NSDate* createdAt = [NSDate dateWithString:self.sceneModel.moment.createdAt format:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" zone:@"UTC"];
    self.createdAt.text = [createdAt timeIntervalDescription];
    [self.avatarImage fromUrl:self.sceneModel.moment.user.avatarUrl diameter:40];
    CGFloat imageHeight = [[UIScreen mainScreen] bounds].size.width * self.sceneModel.moment.ratio;
    if (imageHeight > self.momentImage.bounds.size.height) {
        [self.momentImage removeConstraint:self.momentImageHeightConstraint];
        self.momentImageHeightConstraint = [NSLayoutConstraint
                                            constraintWithItem:self.momentImage
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem: nil
                                            attribute:NSLayoutAttributeNotAnAttribute
                                            multiplier:1.0f
                                            constant:(int)(imageHeight + 0.5)];
        [self.momentImage addConstraint:self.momentImageHeightConstraint];
    }
    [self.momentImage sd_setImageWithURL:[NSURL URLWithString:self.sceneModel.moment.imageUrl]];
    [self.footerlayout constrainTopSpaceToView:self.momentImage predicate:@"-5"];
    [self.likeButton setIcon:[self.sceneModel.moment isLiked:self.sceneModel.userId]];
}

- (void)avatarImagePressed {
    NSString* url = [NSString stringWithFormat:@"iosapp://user?userId=%@", self.sceneModel.moment.userId];
    [URLManager pushURLString:url animated:YES];
}

- (void)likeButtonPressed {
    if ([self.sceneModel.moment.likes containsObject:self.sceneModel.userId]) {
        [self.sceneModel.moment.likes removeObject:self.sceneModel.userId];
        [self.sceneModel.request removeLike:self.sceneModel.moment.objectId userId:self.sceneModel.userId];
    } else {
        [self.sceneModel.moment.likes addObject:self.sceneModel.userId];
        [self.sceneModel.request addLike:self.sceneModel.moment.objectId userId:self.sceneModel.userId];
    }
    [self.sceneModel.moment save];
    [self.likeButton setLike:[self.sceneModel.moment isLiked:self.sceneModel.userId]];
}

- (void)commentButtonPressed {
    NSString* url = [NSString stringWithFormat:@"iosapp://moment?momentId=%@&promptInput=YES", self.sceneModel.moment.objectId];
    [URLManager pushURLString:url animated:YES];
}

- (void)shareButtonPressed {
}

@end
