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
#import "UIColor+EasyExtend.h"
#import "NSDate+Category.h"
#import "URLManager.h"
#import "IconFont.h"
#import "MomentDetailsScene.h"
#import "MomentCellSceneModel.h"
#import "RDNavigationController.h"

@interface MomentCell()

@property (nonatomic, strong)MomentCellSceneModel* sceneModel;
@property (nonatomic, strong)UIView* headerLayout;
@property (nonatomic, strong)AvatarImageView* avatarImage;
@property (nonatomic, strong)UILabel* screenName;
@property (nonatomic, strong)UILabel* createdAt;
@property (nonatomic, strong)UIImageView* momentImage;
@property (nonatomic, strong)UIButton* likeButton;
@property (nonatomic, strong)UIButton* commentButton;
@property (nonatomic, strong)UIView* footerlayout;

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
    
    self.likeButton = [IconFont buttonWithIcon:[IconFont icon:@"ios7HeartOutline" fromFont:ionIcons] fontName:ionIcons size:25 color:[UIColor grayColor]];
    [self.footerlayout addSubview:self.likeButton];
    
    self.commentButton = [IconFont buttonWithIcon:[IconFont icon:@"ios7ChatboxesOutline" fromFont:ionIcons] fontName:ionIcons size:25 color:[UIColor grayColor]];
    [self.commentButton addTarget:self action:@selector(commentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.footerlayout addSubview:self.commentButton];
    
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
    [self.momentImage alignTrailingEdgeWithView:self.momentImage.superview predicate:nil];
}

- (void)initSceneModel {
    self.sceneModel = [MomentCellSceneModel SceneModel];
}

- (void)reloadData:(id)entity {
    self.sceneModel.moment = entity;
    self.screenName.text = self.sceneModel.moment.user.screenName;
    NSDate* createdAt = [NSDate dateWithString:self.sceneModel.moment.createdAt format:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" zone:@"UTC"];
    self.createdAt.text = [createdAt timeIntervalDescription];
    [self.avatarImage fromUrl:self.sceneModel.moment.user.avatarUrl diameter:40];
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat imageHeight = imageWidth * self.sceneModel.moment.ratio;
    [self.momentImage constrainWidth:[NSString stringWithFormat:@"%.0f", imageWidth]
                              height:[NSString stringWithFormat:@"%.0f", imageHeight]];
    [self.momentImage sd_setImageWithURL:[NSURL URLWithString:self.sceneModel.moment.imageUrl]];
    
    [self.footerlayout constrainTopSpaceToView:self.momentImage predicate:@"-5"];
    [self.footerlayout alignCenterXWithView:self.footerlayout.superview predicate:@"0"];
    [self.footerlayout alignBottomEdgeWithView:self.footerlayout.superview predicate:@"0"];
    [self.footerlayout constrainWidth:[NSString stringWithFormat:@"%.0f", imageWidth - 20] height:@"40"];
    
    [self.likeButton alignTop:@"5" leading:@"10" toView:self.likeButton.superview];
    NSArray* layouts = @[ self.likeButton, self.commentButton ];
    [UIView alignTopEdgesOfViews:layouts];
    [UIView spaceOutViewsHorizontally:layouts predicate:@"10"];
}

- (void)avatarImagePressed {
    NSString* url = [NSString stringWithFormat:@"iosapp://user?userId=%@", self.sceneModel.moment.userId];
    [URLManager pushURLString:url animated:YES];
}

- (void)commentButtonPressed {
    MomentDetailsScene* scene = [[MomentDetailsScene alloc] initWithMomentId:self.sceneModel.moment.objectId];
    RDNavigationController* navigationController = [[RDNavigationController alloc] initWithRootViewController:scene];
    [self.viewController presentViewController:navigationController animated:YES completion:nil];
}

@end
