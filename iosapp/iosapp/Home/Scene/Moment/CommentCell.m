//
//  CommentCell.m
//  iosapp
//
//  Created by Simpson Du on 3/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "CommentCell.h"
#import "AvatarImageView.h"
#import "UIColor+EasyExtend.h"
#import "UIView+FLKAutoLayout.h"
#import "NSDate+Category.h"
#import "CommentCellSceneModel.h"
#import "URLManager.h"

@interface CommentCell()

@property (nonatomic, strong)CommentCellSceneModel* sceneModel;
@property (nonatomic, strong)AvatarImageView* avatarImage;
@property (nonatomic, strong)UILabel* screenName;
@property (nonatomic, strong)UILabel* createdAt;
@property (nonatomic, strong)UILabel* content;

@end

@implementation CommentCell

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImagePressed)];
    self.avatarImage = [[AvatarImageView alloc] init];
    [self.avatarImage addGestureRecognizer:tap];
    self.avatarImage.userInteractionEnabled = YES;
    self.avatarImage.multipleTouchEnabled = YES;
    [self.contentView addSubview:self.avatarImage];
    
    self.screenName = [[UILabel alloc] init];
    self.screenName.textColor = HEX_RGB(0xff6060);
    [self.contentView addSubview:self.screenName];
    
    self.createdAt = [[UILabel alloc] init];
    self.createdAt.font = [UIFont systemFontOfSize:12];
    self.createdAt.textColor = [UIColor lightGrayColor];
    self.createdAt.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.createdAt];
    
    self.content = [[UILabel alloc] init];
    self.content.numberOfLines = 0;
    [self.contentView addSubview:self.content];
}

- (void)loadAutoLayout {
    [self.avatarImage alignTop:@"5" leading:@"10" toView:self.avatarImage.superview];
    [self.avatarImage constrainWidth:@"40" height:@"40"];
    
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

- (void)initSceneModel {
    self.sceneModel = [CommentCellSceneModel SceneModel];
}

- (void)reloadData:(id)entity {
    self.sceneModel.comment = entity;
    self.screenName.text = self.sceneModel.comment.user.screenName;
    NSDate* createdAt = [NSDate dateWithString:self.sceneModel.comment.createdAt format:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" zone:@"UTC"];
    self.createdAt.text = [createdAt timeIntervalDescription];
    [self.avatarImage fromUrl:self.sceneModel.comment.user.avatarUrl diameter:40];
    self.content.text = self.sceneModel.comment.content;
}

- (void)avatarImagePressed {
    NSString* url = [NSString stringWithFormat:@"iosapp://user?userId=%@", self.sceneModel.comment.userId];
    [URLManager pushURLString:url animated:YES];
}

@end
