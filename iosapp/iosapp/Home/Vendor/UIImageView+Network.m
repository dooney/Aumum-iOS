//
//  UIImageView+Network.m
//  iosapp
//
//  Created by Simpson Du on 4/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UIImageView+Network.h"
#import "UIImageView+WebCache.h"


@implementation UIImageView (Network)

-(void)net_sd_setImageWithURL:(NSURL *)url{
    [self net_sd_setImageWithURL:url placeholderImage:nil];
}

- (void)net_sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

@end
