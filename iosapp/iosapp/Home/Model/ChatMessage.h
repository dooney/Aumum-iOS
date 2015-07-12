//
//  ChatMessage.h
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ChatMessage_h
#define iosapp_ChatMessage_h

#import "Model.h"
#import "User.h"
#import "EaseMob.h"

@interface ChatMessage : Model

@property (nonatomic, strong)User* user;
@property (nonatomic, strong)NSString* textContent;

- (id)initWithMessage:(EMMessage* )message;

@end

#endif
