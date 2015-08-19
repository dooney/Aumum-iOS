//
//  UserSectionHeader.m
//  iosapp
//
//  Created by Simpson Du on 17/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserSectionHeader.h"
#import "UIColor+EasyExtend.h"
#import "UIView+FLKAutoLayout.h"
#import "URLManager.h"

@interface UserSectionHeader()

@property (nonatomic, strong) UILabel* photosCount;
@property (nonatomic, strong) UILabel* contactsCount;
@property (nonatomic, strong) UILabel* likesCount;
@property (nonatomic, strong) UILabel* photoLabel;
@property (nonatomic, strong) UILabel* contactLabel;
@property (nonatomic, strong) UILabel* likeLabel;

@end

@implementation UserSectionHeader

- (void)reloadData:(UserDetails*)user {
    if (!self.photosCount) {
        self.photosCount = [[UILabel alloc] init];
        self.photosCount.textAlignment = NSTextAlignmentCenter;
        self.photosCount.text = @"123";
        
        [self addSubview:self.photosCount];
        [self.photosCount alignTop:@"8" leading:@"0" toView:self.photosCount.superview];
        [self.photosCount constrainWidth:[NSString stringWithFormat:@"%.f", self.frame.size.width / 3]];
    }
    if (!self.contactsCount) {
        self.contactsCount = [[UILabel alloc] init];
        self.contactsCount.textAlignment = NSTextAlignmentCenter;
        self.contactsCount.text = @"78";
        
        [self addSubview:self.contactsCount];
        [self.contactsCount constrainWidth:[NSString stringWithFormat:@"%.f", self.frame.size.width / 3]];
    }
    if (!self.likesCount) {
        self.likesCount = [[UILabel alloc] init];
        self.likesCount.textAlignment = NSTextAlignmentCenter;
        self.likesCount.text = @"5594";
        
        [self addSubview:self.likesCount];
        [self.likesCount constrainWidth:[NSString stringWithFormat:@"%.f", self.frame.size.width / 3]];
    }
    NSArray* countLayouts = @[ self.photosCount, self.contactsCount, self.likesCount ];
    [UIView spaceOutViewsHorizontally:countLayouts predicate:@"0"];
    [UIView alignTopEdgesOfViews:countLayouts];
    if (!self.photoLabel) {
        self.photoLabel = [[UILabel alloc] init];
        self.photoLabel.textAlignment = NSTextAlignmentCenter;
        self.photoLabel.text = @"照片";
        self.photoLabel.textColor = [UIColor lightGrayColor];
        self.photoLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:self.photoLabel];
        [self.photoLabel alignLeadingEdgeWithView:self.photoLabel.superview predicate:@"0"];
        [self.photoLabel constrainTopSpaceToView:self.photosCount predicate:@"0"];
        [self.photoLabel constrainWidth:[NSString stringWithFormat:@"%.f", self.frame.size.width / 3]];
    }
    if (!self.contactLabel) {
        self.contactLabel = [[UILabel alloc] init];
        self.contactLabel.textAlignment = NSTextAlignmentCenter;
        self.contactLabel.text = @"好友";
        self.contactLabel.textColor = [UIColor lightGrayColor];
        self.contactLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:self.contactLabel];
        [self.contactLabel constrainWidth:[NSString stringWithFormat:@"%.f", self.frame.size.width / 3]];
    }
    if (!self.likeLabel) {
        self.likeLabel = [[UILabel alloc] init];
        self.likeLabel.textAlignment = NSTextAlignmentCenter;
        self.likeLabel.text = @"喜欢";
        self.likeLabel.textColor = [UIColor lightGrayColor];
        self.likeLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:self.likeLabel];
        [self.likeLabel constrainWidth:[NSString stringWithFormat:@"%.f", self.frame.size.width / 3]];
    }
    NSArray* labelLayouts = @[ self.photoLabel, self.contactLabel, self.likeLabel ];
    [UIView spaceOutViewsHorizontally:labelLayouts predicate:@"0"];
    [UIView alignTopEdgesOfViews:labelLayouts];
}

- (void)reloadUser:(UserDetails*)user {
    [self reloadData:user];
}

- (void)reloadProfile:(UserDetails*)user {
    [self reloadData:user];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactTapped)];
    [self.contactsCount addGestureRecognizer:tapGestureRecognizer];
    self.contactsCount.userInteractionEnabled = YES;
}

- (void)contactTapped {
    NSString* url = [NSString stringWithFormat:@"iosapp://contactList"];
    [URLManager pushURLString:url animated:YES];
}

@end
