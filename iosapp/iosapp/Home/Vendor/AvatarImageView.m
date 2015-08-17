//
//  AvatarImageView.m
//  iosapp
//
//  Created by Simpson Du on 16/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AvatarImageView.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char imageURLKey;

@implementation AvatarImageView

- (void)fromUrl:(NSString*)url {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    dispatch_main_async_safe(^{
        self.image = [UIImage imageNamed:@"ic_avatar"];
    });
    
    if (url) {
        __weak __typeof(self)wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    }
}

@end
