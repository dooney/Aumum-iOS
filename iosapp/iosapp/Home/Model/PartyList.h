//
//  PartyList.h
//  iosapp
//
//  Created by Simpson Du on 3/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "Model.h"
#import "Party.h"

@protocol Party <NSObject>

@end

@interface PartyList : Model

@property(nonatomic, retain)NSMutableArray<Party>* results;

@end
