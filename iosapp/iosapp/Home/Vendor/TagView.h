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
#import "ITagViewDelegate.h"

@interface TagView : UIView

@property (nonatomic, assign) id <ITagViewDelegate> delegate;

@property (nonatomic, strong) NSString* text;

- (id)initWithText:(NSString*)text
            isLeft:(BOOL)isLeft
            center:(CGPoint)center;

- (NSString*)getTagJSONString:(CGRect)imageRect;

- (void)updateTag:(NSString*)text;

@end

#endif
