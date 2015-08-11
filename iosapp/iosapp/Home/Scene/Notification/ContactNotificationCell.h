//
//  ContactNotificationCell.h
//  iosapp
//
//  Created by Simpson Du on 9/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ContactNotificationCell_h
#define iosapp_ContactNotificationCell_h

#import "NotificationCell.h"
#import "INotificationCellDelegate.h"

@interface ContactNotificationCell : NotificationCell

@property (nonatomic, assign) id <INotificationCellDelegate> delegate;

@end

#endif
