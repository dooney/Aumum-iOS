//
//  NotificationCell.m
//  iosapp
//
//  Created by Simpson Du on 6/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "NotificationCell.h"
#import "AvatarImageView.h"
#import "UIColor+EasyExtend.h"
#import "UIView+FLKAutoLayout.h"
#import "NSDate+Category.h"
#import "RKNotificationHub.h"
#import "URLManager.h"

@interface NotificationCell()

@property (nonatomic, strong) UIView* leftLayout;
@property (nonatomic, strong) UIView* rightLayout;
@property (nonatomic, strong) AvatarImageView* avatarImage;
@property (nonatomic, strong) UILabel* screenName;
@property (nonatomic, strong) UILabel* createdAt;
@property (nonatomic, strong) UILabel* content;
@property (nonatomic, strong) RKNotificationHub* hub;

@end

@implementation NotificationCell

- (void)commonInit {
    [super commonInit];
    
    [self initView];
    [self addControls];
    [self loadAutoLayout];
}

- (void)initView {
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initRightLayout:(UIView*)rightLayout {
}

- (void)addControls {
    self.leftLayout = [[UIView alloc] init];
    [self.contentView addSubview:self.leftLayout];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImagePressed)];
    self.avatarImage = [[AvatarImageView alloc] init];
    [self.avatarImage addGestureRecognizer:tap];
    self.avatarImage.userInteractionEnabled = YES;
    self.avatarImage.multipleTouchEnabled = YES;
    [self.leftLayout addSubview:self.avatarImage];
    
    self.hub = [[RKNotificationHub alloc] initWithView:self.avatarImage];
    [self.hub setCircleAtFrame:CGRectMake(35, -5, 10, 10)];
    
    self.screenName = [[UILabel alloc] init];
    self.screenName.textColor = HEX_RGB(0xff6060);
    [self.leftLayout addSubview:self.screenName];
    
    self.createdAt = [[UILabel alloc] init];
    self.createdAt.font = [UIFont systemFontOfSize:14];
    self.createdAt.textColor = [UIColor lightGrayColor];
    self.createdAt.textAlignment = NSTextAlignmentRight;
    [self.leftLayout addSubview:self.createdAt];
    
    self.content = [[UILabel alloc] init];
    [self.leftLayout addSubview:self.content];
    
    self.rightLayout = [[UIView alloc] init];
    [self.contentView addSubview:self.rightLayout];
    
    [self initRightLayout:self.rightLayout];
}

- (void)loadAutoLayout {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    [self.leftLayout alignTop:@"10" leading:@"10" toView:self.leftLayout.superview];
    [self.leftLayout constrainWidth:[NSString stringWithFormat:@"%.0f", screenWidth - 10 - 10 - 80 - 10 ] height:@"80"];
    [self.rightLayout constrainWidth:@"80" height:@"80"];
    NSArray* layouts = @[ self.leftLayout, self.rightLayout ];
    [UIView alignTopEdgesOfViews:layouts];
    [UIView spaceOutViewsHorizontally:layouts predicate:@"10"];
    
    [self.avatarImage alignTop:@"0" leading:@"0" toView:self.avatarImage.superview];
    [self.avatarImage constrainWidth:@"40" height:@"40"];
    [self.screenName constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.screenName alignTopEdgeWithView:self.avatarImage predicate:nil];
    [self.screenName alignTrailingEdgeWithView:self.screenName.superview predicate:nil];
    [self.createdAt alignBottomEdgeWithView:self.avatarImage predicate:nil];
    [self.content constrainTopSpaceToView:self.createdAt predicate:@"10"];
    [self.content alignTrailingEdgeWithView:self.content.superview predicate:nil];
    NSArray* leftLayouts = @[ self.screenName, self.createdAt, self.content ];
    [UIView alignLeadingEdgesOfViews:leftLayouts];
}

- (void)reloadData:(id)entity {
    _notification = entity;
    self.screenName.text = _notification.screenName;
    NSDate* createdAt = [NSDate dateWithString:_notification.createdAt format:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" zone:@"UTC"];
    self.createdAt.text = [createdAt timeIntervalDescription];
    [self.avatarImage fromUrl:_notification.avatarUrl diameter:40];
    if (!_notification.isRead) {
        [self.hub increment];
        [self.hub hideCount];
    } else {
        self.hub.count = 0;
    }
    switch (_notification.type) {
        case LIKE_MOMENT:
            self.content.text = NSLocalizedString(@"label.likeYourPhoto", nil);
            break;
        case COMMENT_MOMENT:
        case NEW_CONTACT:
            self.content.text = _notification.content;
            break;
        default:
            break;
    }
}

- (void)avatarImagePressed {
    NSString* url = [NSString stringWithFormat:@"iosapp://user?userId=%@", _notification.userId];
    [URLManager pushURLString:url animated:YES];
}

@end
