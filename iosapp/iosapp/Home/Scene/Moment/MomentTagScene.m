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
#import "AddTagScene.h"
#import "IAddTagDelegate.h"

@interface MomentTagScene()<IAddTagDelegate>
{
    CGRect _rect;
}

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIButton* tagButton;
@property (nonatomic, strong) UIButton* locationButton;
@property (nonatomic, strong) PinView* pinView;
@property (nonatomic, strong) NSMutableArray* tagList;
@property (nonatomic, strong) UIView* footerView;

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

- (void)viewDidAppear:(BOOL)animated {
    _rect = [self getFrameSizeForImage:self.image inImageView:self.imageView];
}

- (void)initView {
    self.navigationItem.title = NSLocalizedString(@"label.tagging", nil);
    self.view.backgroundColor = HEX_RGB(0x333333);
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
    
    self.footerView = [[UIView alloc] init];
    self.footerView.backgroundColor = HEX_RGB(0x1f2226);
    [self.view addSubview:self.footerView];
}

- (void)loadAutoLayout {
    [self.imageView alignTop:@"64" leading:@"0" bottom:@"-90" trailing:@"0" toView:self.imageView.superview];
    
    [self.tagButton constrainWidth:@"50" height:@"50"];
    [self.tagButton alignCenterXWithView:self.tagButton.superview predicate:@"-50"];
    
    [self.locationButton constrainWidth:@"50" height:@"50"];
    [self.locationButton alignCenterXWithView:self.locationButton.superview predicate:@"50"];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [self.footerView constrainWidth:[NSString stringWithFormat:@"%.f", width]
                             height:@"90"];
    [self.footerView alignTop:nil leading:@"0" bottom:@"0" trailing:nil toView:self.footerView.superview];
}

- (void)doneButtonPressed {
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:context];
    UIImage* preview = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSMutableArray* tagList = nil;
    if (self.tagList.count > 0) {
        tagList = [NSMutableArray array];
        for (TagView* tagView in self.tagList) {
            [tagList addObject:[tagView getTagJSONString:_rect]];
        }
    }
    NewMomentScene* scene = [[NewMomentScene alloc] initWithImage:self.image preview:preview tagList:tagList];
    [self.navigationController pushViewController:scene animated:YES];
}

- (void)tapImage:(UITapGestureRecognizer *)tgr {
    CGPoint point = [tgr locationInView:self.imageView];
    if (![self checkBoundry:point]) {
        return;
    }
    
    if (self.pinView.isHidden) {
        self.pinView.center = point;
        self.pinView.hidden = NO;
    } else {
        self.pinView.hidden = YES;
    }
    
    if (self.tagButton.isHidden) {
        self.tagButton.hidden = NO;
        POPSpringAnimation* tagPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        tagPositionAnimation.fromValue = @(self.tagButton.superview.center.y - 50);
        tagPositionAnimation.toValue = @(self.tagButton.superview.center.y);
        tagPositionAnimation.springBounciness = 10;
        [self.tagButton pop_addAnimation:tagPositionAnimation forKey:@"tagPositionAnimation"];
    } else {
        self.tagButton.hidden = YES;
    }
    
    if (self.locationButton.isHidden) {
        self.locationButton.hidden = NO;
        POPSpringAnimation* locationPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        locationPositionAnimation.fromValue = @(self.locationButton.superview.center.y - 25);
        locationPositionAnimation.toValue = @(self.locationButton.superview.center.y);
        locationPositionAnimation.springBounciness = 10;
        [self.locationButton pop_addAnimation:locationPositionAnimation forKey:@"locationPositionAnimation"];
    } else {
        self.locationButton.hidden = YES;
    }
}

- (void)tagButtonPressed {
    AddTagScene* scene = [[AddTagScene alloc] init];
    scene.delegate = self;
    [self.navigationController pushViewController:scene animated:YES];
}

- (void)panTag:(TagPanGestureRecognizer*)pgr {
    TagView* tagView = [self.tagList objectAtIndex:pgr.tag];
    CGPoint pos = [pgr translationInView:tagView];
    CGPoint point = CGPointMake(pgr.view.center.x + pos.x, pgr.view.center.y + pos.y);
    if (![self checkBoundry:point]) {
        return;
    }
    tagView.center = point;
    [pgr setTranslation:CGPointMake(0, 0) inView:tagView];
    [tagView updateIfNeeded:tagView.center.x > self.imageView.bounds.size.width / 2];
}

- (CGRect)getFrameSizeForImage:(UIImage *)image inImageView:(UIImageView *)imageView {
    float hfactor = image.size.width / imageView.frame.size.width;
    float vfactor = image.size.height / imageView.frame.size.height;
    float factor = fmax(hfactor, vfactor);
    float newWidth = image.size.width / factor;
    float newHeight = image.size.height / factor;
    float leftOffset = (imageView.frame.size.width - newWidth) / 2;
    float topOffset = (imageView.frame.size.height - newHeight) / 2;
    return CGRectMake(leftOffset, topOffset, newWidth, newHeight);
}

- (void)getTag:(NSString*)tag {
    TagView* tagView = [[TagView alloc] initWithText:tag
                                              isLeft:self.pinView.center.x > self.imageView.bounds.size.width / 2
                                              center:self.pinView.center];
    TagPanGestureRecognizer* pan = [[TagPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTag:)];
    pan.tag = self.tagList.count;
    [tagView addGestureRecognizer:pan];
    [self.imageView addSubview:tagView];
    [self.tagList addObject:tagView];
    
    self.pinView.hidden = YES;
    self.tagButton.hidden = YES;
    self.locationButton.hidden = YES;
}

- (BOOL)checkBoundry:(CGPoint)point {
    if (point.x < _rect.origin.x ||
        point.y < _rect.origin.y + 15 ||
        point.x > _rect.origin.x + _rect.size.width ||
        point.y > _rect.origin.y + _rect.size.height - 15) {
        return NO;
    }
    return YES;
}

@end
