//
//  INotificationCellDelegate.h
//  iosapp
//
//  Created by Simpson Du on 9/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_INotificationCellDelegate_h
#define iosapp_INotificationCellDelegate_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol INotificationCellDelegate<NSObject>

- (void)didPressAcceptButton:(UITableViewCell*)cell;

@end

#endif
