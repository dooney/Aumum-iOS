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

@interface TagView()
{
    UIImage* _bubbleImage;
}

@property (nonatomic, strong) PinView* pinView;
@property (nonatomic, strong) UIImageView* tagBackground;
@property (nonatomic, strong) UILabel* tagText;

@end

@implementation TagView

- (id)initWithText:(NSString*)text point:(CGPoint)point {
    self = [super init];
    if (self) {
        _bubbleImage = [[SWNinePatchImageFactory createResizableNinePatchImageNamed:@"tag_text_bg_left.9"]
                        resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 10) resizingMode:UIImageResizingModeStretch];
        
        self.pinView = [[PinView alloc] init];
        [self addSubview:self.pinView];
        
        self.tagBackground = [[UIImageView alloc] init];
        self.tagBackground.alpha = 0.8;
        self.tagBackground.image = _bubbleImage;
        [self addSubview:self.tagBackground];
        
        self.tagText = [[UILabel alloc] init];
        self.tagText.text = text;
        self.tagText.textColor = [UIColor whiteColor];
        self.tagText.font = [UIFont systemFontOfSize:14];
        [self.tagBackground addSubview:self.tagText];
        
        [self.pinView alignCenterYWithView:self.pinView.superview predicate:@"0"];
        [self.pinView alignLeadingEdgeWithView:self.pinView.superview predicate:@"0"];
        
        CGSize labelSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        CGFloat width = labelSize.width + 50;
        [self constrainWidth:[NSString stringWithFormat:@"%.f", width]
                      height:@"30"];
        [self.tagBackground constrainWidth:[NSString stringWithFormat:@"%.f", width - 20]
                                    height:@"30"];
        [self.tagBackground alignCenterYWithView:self.tagBackground.superview predicate:@"0"];
        [self.tagBackground alignLeadingEdgeWithView:self.tagBackground.superview predicate:@"20"];
        
        [self.tagText alignCenterYWithView:self.tagText.superview predicate:@"0"];
        [self.tagText alignCenterXWithView:self.tagText.superview predicate:@"5"];
        
        self.center = CGPointMake(point.x - 9 + width / 2, point.y);
    }
    return self;
}

@end
