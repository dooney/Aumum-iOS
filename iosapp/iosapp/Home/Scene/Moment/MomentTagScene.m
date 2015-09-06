//
//  MomentTagScene.m
//  iosapp
//
//  Created by Simpson Du on 3/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentTagScene.h"
#import "UIView+FLKAutoLayout.h"
#import "NewMomentScene.h"
#import "IconFont.h"
#import <POP.h>
#import "PinView.h"
#import "TagView.h"
#import "TagPanGestureRecognizer.h"

@interface MomentTagScene()

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIButton* tagButton;
@property (nonatomic, strong) UIButton* locationButton;
@property (nonatomic, strong) PinView* pinView;
@property (nonatomic, strong) NSMutableArray* tagList;

@end

@implementation MomentTagScene

- (id)initWithImage:(UIImage*)image {
    self = [super init];
    if (self) {
        self.image = image;
        self.tagList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addControls];
    [self loadAutoLayout];
}

- (void)initView {
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)addControls {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [self.imageView addGestureRecognizer:tap];
    [self.view addSubview:self.imageView];
    
    self.pinView = [[PinView alloc] init];
    self.pinView.hidden = YES;
    [self.imageView addSubview:self.pinView];
    
    self.tagButton = [[UIButton alloc] init];
    self.tagButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    self.tagButton.layer.cornerRadius = 25;
    [self.tagButton setImage:[IconFont imageWithIcon:[IconFont icon:@"ios7Pricetag" fromFont:ionIcons] fontName:ionIcons iconColor:[UIColor whiteColor] iconSize:25] forState:UIControlStateNormal];
    self.tagButton.hidden = YES;
    [self.tagButton addTarget:self action:@selector(tagButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.tagButton];
    
    self.locationButton = [[UIButton alloc] init];
    self.locationButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    self.locationButton.layer.cornerRadius = 25;
    [self.locationButton setImage:[IconFont imageWithIcon:[IconFont icon:@"ios7Location" fromFont:ionIcons] fontName:ionIcons iconColor:[UIColor whiteColor] iconSize:25] forState:UIControlStateNormal];
    self.locationButton.hidden = YES;
    [self.imageView addSubview:self.locationButton];
}

- (void)loadAutoLayout {
    [self.imageView alignToView:self.imageView.superview];
    
    [self.pinView alignCenterWithView:self.pinView.superview];
    
    [self.tagButton constrainWidth:@"50" height:@"50"];
    [self.tagButton alignCenterYWithView:self.tagButton.superview predicate:@"-50"];
    [self.tagButton alignCenterXWithView:self.tagButton.superview predicate:@"-50"];
    
    [self.locationButton constrainWidth:@"50" height:@"50"];
    [self.locationButton alignCenterYWithView:self.locationButton.superview predicate:@"-25"];
    [self.locationButton alignCenterXWithView:self.locationButton.superview predicate:@"50"];
}

- (void)doneButtonPressed {
    NewMomentScene* scene = [[NewMomentScene alloc] initWithImage:self.image];
    [self.navigationController pushViewController:scene animated:YES];
}

- (void)tapImage:(UITapGestureRecognizer *)tgr {
    self.pinView.center = [tgr locationInView:self.imageView];
    self.pinView.hidden = NO;
    
    if (self.tagButton.isHidden) {
        POPSpringAnimation* tagPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        tagPositionAnimation.toValue = @(self.tagButton.superview.center.y);
        tagPositionAnimation.springBounciness = 10;
        self.tagButton.hidden = NO;
        [self.tagButton pop_addAnimation:tagPositionAnimation forKey:@"tagPositionAnimation"];
    }
    
    if (self.locationButton.isHidden) {
        POPSpringAnimation* locationPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        locationPositionAnimation.toValue = @(self.locationButton.superview.center.y);
        locationPositionAnimation.springBounciness = 10;
        self.locationButton.hidden = NO;
        [self.locationButton pop_addAnimation:locationPositionAnimation forKey:@"locationPositionAnimation"];
    }
}

- (void)tagButtonPressed {
    TagView* tagView = [[TagView alloc] initWithText:@"PRADA" point:self.pinView.center];
    TagPanGestureRecognizer* pan = [[TagPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTag:)];
    pan.tag = self.tagList.count;
    [tagView addGestureRecognizer:pan];
    [self.imageView addSubview:tagView];
    [self.tagList addObject:tagView];
    
    self.pinView.hidden = YES;
    self.tagButton.hidden = YES;
    self.locationButton.hidden = YES;
}

- (void)panTag:(TagPanGestureRecognizer*)pgr {
    TagView* tagView = [self.tagList objectAtIndex:pgr.tag];
    CGPoint point = [pgr translationInView:tagView];
    tagView.center = CGPointMake(pgr.view.center.x + point.x, pgr.view.center.y + point.y);
    [pgr setTranslation:CGPointMake(0, 0) inView:tagView];
}

@end
