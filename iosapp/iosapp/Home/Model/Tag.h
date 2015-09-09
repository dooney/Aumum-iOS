//
//  Tag.h
//  iosapp
//
//  Created by Simpson Du on 8/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Tag_h
#define iosapp_Tag_h

#import <UIKit/UIKit.h>
#import "JSONModel.h"

@interface Tag : JSONModel

@property (nonatomic, strong) NSString* text;
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end

#endif
