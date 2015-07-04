//
//  MomentCell.h
//  iosapp
//
//  Created by Simpson Du on 3/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_MomentCell_h
#define iosapp_MomentCell_h

#import "EzTableViewCell.h"
#import "Moment.h"

@interface MomentCell : EzTableViewCell

- (void)refresh:(Moment*)moment;

@end

#endif
