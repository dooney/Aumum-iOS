//
//  BaseScene.m
//  iosapp
//
//  Created by Simpson Du on 20/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "BaseScene.h"
#import "TSMessage.h"

@implementation BaseScene

- (void)showError:(NSError*)error {
    [TSMessage showNotificationWithTitle:nil
                                subtitle:error.localizedDescription
                                    type:TSMessageNotificationTypeError];
}

- (void)showSuccess:(NSString*)title message:(NSString*)message {
    [TSMessage showNotificationWithTitle:title
                                subtitle:message
                                    type:TSMessageNotificationTypeSuccess];
}

@end
