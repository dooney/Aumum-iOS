//
//  TagInfo.h
//  iosapp
//
//  Created by Simpson Du on 8/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_TagInfo_h
#define iosapp_TagInfo_h

#import <UIKit/UIKit.h>
#import "JSONModel.h"

@interface TagInfo : JSONModel

@property (nonatomic, strong) NSString* text;
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end

#endif
