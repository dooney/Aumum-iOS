//
//  ITagViewDelegate.h
//  iosapp
//
//  Created by Simpson Du on 17/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ITagViewDelegate_h
#define iosapp_ITagViewDelegate_h

#import <Foundation/Foundation.h>

@protocol ITagViewDelegate<NSObject>

- (void)panTag:(UIView*)tagView pgr:(UIPanGestureRecognizer*)pgr;
- (void)longPressTag:(UIView*)tagView;

@end

#endif
