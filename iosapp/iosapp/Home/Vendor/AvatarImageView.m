//
//  AvatarImageView.m
//  iosapp
//
//  Created by Simpson Du on 16/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AvatarImageView.h"
#import "UIImageView+WebCache.h"

@implementation AvatarImageView

- (id)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)fromUrl:(NSString*)url diameter:(NSInteger)diameter {
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:@"ic_avatar_circle"]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGRect frame = CGRectMake(0.0f, 0.0f, diameter, diameter);
        UIImage *newImage = nil;
        UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale); {
            UIBezierPath *imgPath = [UIBezierPath bezierPathWithOvalInRect:frame];
            [imgPath addClip];
            [image drawInRect:frame];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
        self.image = newImage;
    }];
}

#pragma mark - Touche methods

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = 1;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.alpha = 0.6;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.alpha = 1.0;
    if (self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(avatarViewOnTouchAction)]) {
        [self.delegate avatarViewOnTouchAction];
        return;
    }
}

@end
