//
//  ChatMessage.m
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

- (id)initWithMessage:(EMMessage* )message {
    self = [super init];
    if (self) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        self.textContent = ((EMTextMessageBody *)messageBody).text;
    }
    return self;
}

@end
