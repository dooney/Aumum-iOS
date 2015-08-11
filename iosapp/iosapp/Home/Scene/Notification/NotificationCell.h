//
//  NotificationCell.h
//  iosapp
//
//  Created by Simpson Du on 6/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_NotificationCell_h
#define iosapp_NotificationCell_h

#import "EzTableViewCell.h"
#import "Notification.h"

@interface NotificationCell : EzTableViewCell

@property (nonatomic, strong) Notification* notification;

- (void)initRightLayout:(UIView*)rightLayout;

@end

#endif
