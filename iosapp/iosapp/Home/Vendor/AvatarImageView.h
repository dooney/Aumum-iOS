//
//  AvatarImageView.h
//  iosapp
//
//  Created by Simpson Du on 16/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_AvatarImageView_h
#define iosapp_AvatarImageView_h

#import <UIKit/UIKit.h>

@interface AvatarImageView : UIImageView

- (void)fromUrl:(NSString*)url diameter:(NSInteger)diameter;

@end

#endif
