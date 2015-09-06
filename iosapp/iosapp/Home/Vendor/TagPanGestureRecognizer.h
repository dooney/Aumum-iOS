//
//  TagPanGestureRecognizer.h
//  iosapp
//
//  Created by Simpson Du on 6/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_TagPanGestureRecognizer_h
#define iosapp_TagPanGestureRecognizer_h

#import <UIKit/UIKit.h>

@interface TagPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) NSUInteger tag;

@end

#endif
