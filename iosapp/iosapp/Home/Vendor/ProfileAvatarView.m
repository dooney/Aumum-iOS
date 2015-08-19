//
//  ProfileAvatarView.m
//  iosapp
//
//  Created by Simpson Du on 18/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ProfileAvatarView.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char imageURLKey;

@implementation ProfileAvatarView{
    CALayer *borderLayer;
    CALayer *imageLayer;
    UIImage *_image;
}

@synthesize borderWidth = _borderWidth;
@synthesize borderColor = _borderColor;
@synthesize shadowEnable = _shadowEnable;

#pragma mark - Instance Methods
- (id)init {
    self = [super init];
    if(self) {
        [self initProperties];
    }
    return self;
}

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

-(UIImage *)image {
    return _image;
}

- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    [self drawAvatarView];
}


-(void)setShadowEnable:(BOOL)shadowEnable {
    
    _shadowEnable = shadowEnable;
    
    if (shadowEnable == true) {
        borderLayer.shadowColor = [UIColor blackColor].CGColor;
        borderLayer.shadowRadius = 5.f;
        borderLayer.shadowOffset = CGSizeMake(0.f, 5.f);
        borderLayer.shadowOpacity = 0.8f;
    }
    else {
        borderLayer.shadowOffset = CGSizeZero;
        borderLayer.shadowRadius = 0;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
}

- (void)initProperties {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.borderColor = [UIColor whiteColor];
    self.borderWidth = self.frame.size.width*0.05;
    self.shadowEnable = NO;
    self.diameter = 40;
    self.userInteractionEnabled = YES;
    
}

#pragma mark - Draw Avatar View Layers

- (void)drawAvatarView {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [self.layer setMasksToBounds:NO];
    
    borderLayer = [CALayer layer];
    
    UIColor *bgColor = [UIColor colorWithRed:224.0f/255.0f
                                       green:224.0f/255.0f blue:224.0f/255.0f  alpha:1.0f];
    
    borderLayer.backgroundColor = bgColor.CGColor;
    
    borderLayer.contentsScale = [UIScreen mainScreen].scale;
    
    if (self.shadowEnable) {
        borderLayer.shadowColor = [UIColor blackColor].CGColor;
        borderLayer.shadowRadius = 5.f;
        borderLayer.shadowOffset = CGSizeMake(0.f, 5.f);
        borderLayer.shadowOpacity = 0.8f;
    }
    
    borderLayer.frame = CGRectMake(0, 0,
                                   self.layer.bounds.size.width > 0 ? self.layer.bounds.size.width : self.diameter,
                                   self.layer.bounds.size.height > 0 ? self.layer.bounds.size.height : self.diameter);
    
    borderLayer.borderColor = self.borderColor.CGColor;
    borderLayer.borderWidth = self.borderWidth;
    
    borderLayer.cornerRadius = roundf(borderLayer.frame.size.width / 2);
    
    [self.layer addSublayer:borderLayer];
    
    imageLayer = [CALayer layer];
    imageLayer.frame = borderLayer.bounds;
    imageLayer.contentsScale = [UIScreen mainScreen].scale;
    
    
    if (_image != nil) {
        imageLayer.contents = (id) _image.CGImage;
        imageLayer.cornerRadius =roundf(borderLayer.frame.size.width / 2);
        
        imageLayer.masksToBounds = YES;
        
        [borderLayer addSublayer:imageLayer];
    }
}

@end
