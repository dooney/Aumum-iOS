//
//  Tab.h
//  iosapp
//
//  Created by Simpson Du on 6/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Tab_h
#define iosapp_Tab_h

#import "BaseModel.h"

@interface Tab : BaseModel

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, assign) NSInteger unread;

- (id)initWithId:(NSString*)objectId;

@end

#endif
