//
//  MomentList.h
//  iosapp
//
//  Created by Simpson Du on 2/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_MomentList_h
#define iosapp_MomentList_h

#import "Moment.h"
#import "JSONModel.h"

@interface MomentList : JSONModel

@property (nonatomic, strong) NSMutableArray<Moment, Optional>* results;

@end

#endif
