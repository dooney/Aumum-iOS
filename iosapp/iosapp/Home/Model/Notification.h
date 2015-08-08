//
//  Notification.h
//  iosapp
//
//  Created by Simpson Du on 6/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Notification_h
#define iosapp_Notification_h

#import "BaseModel.h"

@interface Notification : BaseModel

typedef enum {
    NEW_MOMENT = 1,
    LIKE_MOMENT = 2,
    COMMENT_MOMENT = 3,
    NEW_CONTACT = 11
} NOTIFICATION_TYPE;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, strong) NSString* createdAt;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* screenName;
@property (nonatomic, strong) NSString* avatarUrl;
@property (nonatomic, strong) NSString* momentId;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* content;

@end

@protocol Notification

@end

#endif
