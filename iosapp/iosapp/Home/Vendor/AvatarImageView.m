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

- (void)fromUrl:(NSString*)url diameter:(NSInteger)diameter {
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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

@end
