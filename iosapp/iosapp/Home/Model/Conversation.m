//
//  Conversation.m
//  iosapp
//
//  Created by Simpson Du on 14/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "Conversation.h"

@implementation Conversation

- (id)initWithEMConversation:(EMConversation*)emConversation {
    self = [super init];
    if (self) {
        self.chatId = emConversation.chatter;
        id<IEMMessageBody> messageBody = [emConversation.latestMessage.messageBodies firstObject];
        self.latestMessage = ((EMTextMessageBody *)messageBody).text;
    }
    return self;
}

@end
