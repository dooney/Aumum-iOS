//
//  IEditAvatarDelegate.h
//  iosapp
//
//  Created by Simpson Du on 23/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_IEditAvatarDelegate_h
#define iosapp_IEditAvatarDelegate_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol IEditAvatarDelegate<NSObject>

- (void)didPressEditButton:(UIImage*)avatarImage;

@end

#endif
