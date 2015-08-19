//
//  ProfileAvatarView.h
//  iosapp
//
//  Created by Simpson Du on 18/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ProfileAvatarView_h
#define iosapp_ProfileAvatarView_h

#import <UIKit/UIKit.h>

@interface ProfileAvatarView : UIView

@property (nonatomic) BOOL shadowEnable; // default is YES
@property (nonatomic) CGFloat borderWidth; // default is [UIColor whiteColor]
@property (nonatomic, strong) UIColor *borderColor; // default is [UIColor whiteColor]
@property (nonatomic, strong) UIImage *image; // default is NIL
@property (nonatomic) CGFloat diameter; // default is 40

- (void)fromUrl:(NSString*)url;

@end

#endif
