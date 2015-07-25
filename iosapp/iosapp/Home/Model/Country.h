//
//  Country.h
//  iosapp
//
//  Created by Simpson Du on 23/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Country_h
#define iosapp_Country_h

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)NSString* code;

- (id)initWithName:(NSString*)name code:(NSString*)code;

@end

#endif
