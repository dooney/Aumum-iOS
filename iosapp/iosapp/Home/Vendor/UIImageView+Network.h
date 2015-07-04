//
//  UIImageView+Network.h
//  iosapp
//
//  Created by Simpson Du on 4/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UIImageView_Network_h
#define iosapp_UIImageView_Network_h

#import <UIKit/UIKit.h>

@interface UIImageView (Network)

- (void)net_sd_setImageWithURL:(NSURL *)url;
- (void)net_sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end

#endif
