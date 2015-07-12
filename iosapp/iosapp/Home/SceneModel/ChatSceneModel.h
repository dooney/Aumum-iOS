//
//  ChatSceneModel.h
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ChatSceneModel_h
#define iosapp_ChatSceneModel_h

#import "SceneModel.h"
#import "EaseMob.h"
#import "UserRequest.h"
#import "User.h"

@interface ChatSceneModel : SceneModel

@property (nonatomic, strong) EMConversation* conversation;
@property (nonatomic, strong) NSDate* chatTagDate;
@property (nonatomic, strong) NSMutableArray* dataSet;
@property (nonatomic, strong) NSMutableArray* messages;
@property (nonatomic, assign) int messageCount;
@property (nonatomic, strong) NSIndexPath* scrollTo;
@property (nonatomic, strong) UserRequest* userRequest;
@property (nonatomic, strong) User* user;

- (void)onUserRequest:(void (^)(User* user))successHandler
                error:(void (^)(NSError* error))errorHandler;

@end

#endif
