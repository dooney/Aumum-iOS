//
//  ChatSendHelper.h
//  iosapp
//
//  Created by Simpson Du on 15/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ChatSendHelper_h
#define iosapp_ChatSendHelper_h

#import "EaseMob.h"

@interface ChatSendHelper : NSObject

+(EMMessage *)sendTextMessageWithString:(NSString *)str
                             toUsername:(NSString *)username
                            messageType:(EMMessageType)type
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext;

@end

#endif
