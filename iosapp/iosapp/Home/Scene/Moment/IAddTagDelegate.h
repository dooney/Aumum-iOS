//
//  IAddTagDelegate.h
//  iosapp
//
//  Created by Simpson Du on 10/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_IAddTagDelegate_h
#define iosapp_IAddTagDelegate_h

#import <Foundation/Foundation.h>

@protocol IAddTagDelegate<NSObject>

- (void)getTag:(NSString*)tag;
- (void)updateTag:(NSString*)tag;

@end

#endif
