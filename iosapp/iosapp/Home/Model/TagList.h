//
//  TagList.h
//  iosapp
//
//  Created by Simpson Du on 14/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_TagList_h
#define iosapp_TagList_h

#import "Tag.h"
#import "JSONModel.h"

@interface TagList : JSONModel

@property (nonatomic, strong) NSMutableArray<Tag>* results;

@end

#endif
