//
//  ConversationListSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 14/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ConversationListSceneModel_h
#define iosapp_ConversationListSceneModel_h

#import "BaseSceneModel.h"
#import "UserListByChatIdRequest.h"
#import "UserByIdRequest.h"

@interface ConversationListSceneModel : BaseSceneModel

@property (nonatomic, strong) NSMutableArray* dataSet;
@property (nonatomic, strong) UserListByChatIdRequest* userListByChatIdRequest;
@property (nonatomic, strong) UserByIdRequest* userByIdRequest;

@end

#endif
