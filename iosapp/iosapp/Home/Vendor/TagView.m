//
//  TagView.m
//  iosapp
//
//  Created by Simpson Du on 6/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "TagView.h"
#import "PinView.h"
#import "SWNinePatchImageFactory.h"
#import "UIView+FLKAutoLayout.h"
#import "TagInfo.h"

@interface TagView()
{
    BOOL _isLeft;
}

@property (nonatomic, strong) PinView* pinView;
@property (nonatomic, strong) NSMutableArray* tagBackground;
@property (nonatomic, strong) NSMutableArray* tagText;
@property (nonatomic, strong) NSLayoutConstraint* widthConstraint;

@end

@implementation TagView

- (id)initWithText:(NSString*)text
            isLeft:(BOOL)isLeft
            center:(CGPoint)center {
    self = [super init];
    if (self) {
        self.pinView = [[PinView alloc] init];
        [self addSubview:self.pinView];
        [self.pinView alignCenterYWithView:self.pinView.superview predicate:@"0"];
        
        [self updateText:text];
        [self constrainHeight:@"30"];
        
        [self updateDirection:isLeft];
        
        self.center = center;
    }
    return self;
}

- (void)updateText:(NSString*)text {
    self.text = text;
    if (self.tagBackground) {
        for (UIView* view in self.tagBackground) {
            [view removeFromSuperview];
        }
    }
    self.tagBackground = [NSMutableArray array];
    self.tagText = [NSMutableArray array];
    CGFloat textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    for (int i = 0; i < 2; i++) {
        UIImageView* tagBackground = [[UIImageView alloc] init];
        tagBackground.alpha = 0.8;
        if (i == 0) {
            tagBackground.image = [[SWNinePatchImageFactory createResizableNinePatchImageNamed:@"tag_text_bg_right.9"]
                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 30) resizingMode:UIImageResizingModeStretch];
        } else {
            tagBackground.image = [[SWNinePatchImageFactory createResizableNinePatchImageNamed:@"tag_text_bg_left.9"]
                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 10) resizingMode:UIImageResizingModeStretch];
        }
        [self addSubview:tagBackground];
        [self.tagBackground addObject:tagBackground];
        [tagBackground constrainWidth:[NSString stringWithFormat:@"%.f", textSize + 30]
                               height:@"30"];
        [tagBackground alignCenterYWithView:tagBackground.superview predicate:@"0"];
        
        tagBackground.userInteractionEnabled = YES;
        UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTag:)];
        UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTag:)];
        UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTag:)];
        [tagBackground addGestureRecognizer:pgr];
        [tagBackground addGestureRecognizer:tgr];
        [tagBackground addGestureRecognizer:lpgr];
        
        UILabel* tagText = [[UILabel alloc] init];
        tagText.text = text;
        tagText.textColor = [UIColor whiteColor];
        tagText.font = [UIFont systemFontOfSize:14];
        [tagBackground addSubview:tagText];
        [self.tagText addObject:tagText];
        [tagText alignCenterYWithView:tagText.superview predicate:@"0"];
        if (i == 0) {
            [tagText alignCenterXWithView:tagText.superview predicate:@"-5"];
        } else {
            [tagText alignCenterXWithView:tagText.superview predicate:@"5"];
        }
    }
    
    CGFloat width = ([text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width + 30) * 2 + 2 + 18 + 2;
    if (self.widthConstraint) {
        [self removeConstraint:self.widthConstraint];
    }
    self.widthConstraint = [NSLayoutConstraint
                            constraintWithItem:self
                            attribute:NSLayoutAttributeWidth
                            relatedBy:NSLayoutRelationEqual
                            toItem: nil
                            attribute:NSLayoutAttributeNotAnAttribute
                            multiplier:1.0f
                            constant:width];
    [self addConstraint:self.widthConstraint];
    [self.tagBackground[0] alignLeadingEdgeWithView:self predicate:@"0"];
    NSArray* layouts = @[ self.tagBackground[0], self.pinView, self.tagBackground[1] ];
    [UIView spaceOutViewsHorizontally:layouts predicate:@"2"];
}

- (void)updateDirection:(BOOL)isLeft {
    _isLeft = isLeft;
    UIView* tagBackgroundRight = [self.tagBackground objectAtIndex:0];
    UIView* tagBackgroundLeft = [self.tagBackground objectAtIndex:1];
    tagBackgroundRight.hidden = _isLeft;
    tagBackgroundLeft.hidden = !_isLeft;
}

- (NSString*)getTagJSONString:(CGRect)imageRect {
    TagInfo* tag = [[TagInfo alloc] init];
    tag.text = self.text;
    tag.isLeft = _isLeft;
    tag.x = (self.center.x - imageRect.origin.x) / imageRect.size.width;
    tag.y = (self.center.y - imageRect.origin.y) / imageRect.size.height;
    return [tag toJSONString];
}

- (void)panTag:(UIPanGestureRecognizer*)pgr {
    [self.delegate panTag:self pgr:pgr];
}

- (void)tapTag:(UITapGestureRecognizer*)tgr {
    [self updateDirection:!_isLeft];
}

- (void)longPressTag:(UILongPressGestureRecognizer*)lpgr {
    [self.delegate longPressTag:self];
}

- (void)updateTag:(NSString*)text {
    [self updateText:text];
    [self updateDirection:_isLeft];
}

@end
