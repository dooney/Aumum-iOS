//
//  Conversation.h
//  iosapp
//
//  Created by Simpson Du on 14/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Conversation_h
#define iosapp_Conversation_h

#import "Model.h"
#import "User.h"
#import "EaseMob.h"

@interface Conversation : Model

@property (nonatomic, strong)NSString* chatId;
@property (nonatomic, strong)User* user;
@property (nonatomic, strong)NSString* latestMessage;

- (id)initWithEMConversation:(EMConversation*)emConversation;

@end

#endif
