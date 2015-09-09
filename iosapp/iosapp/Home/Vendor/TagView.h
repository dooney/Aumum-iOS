//
//  TagView.h
//  iosapp
//
//  Created by Simpson Du on 6/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_TagView_h
#define iosapp_TagView_h

#import <UIKit/UIKit.h>

@interface TagView : UIView

- (id)initWithText:(NSString*)text
            isLeft:(BOOL)isLeft
            center:(CGPoint)center;

- (void)updateIfNeeded:(BOOL)isLeft;

- (NSString*)getTagJSONString:(CGRect)imageRect;

@end

#endif
