//
//  ConversationListSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 14/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ConversationListSceneModel_h
#define iosapp_ConversationListSceneModel_h

#import "SceneModel.h"
#import "UserListByChatIdRequest.h"

@interface ConversationListSceneModel : SceneModel

@property (nonatomic, strong) NSMutableArray* dataSet;
@property (nonatomic, strong) UserListByChatIdRequest* userListByChatIdRequest;

@end

#endif