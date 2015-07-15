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

@interface ChatSceneModel : SceneModel

@property (nonatomic, strong) EMConversation* conversation;
@property (nonatomic, strong) NSDate* chatTagDate;
@property (nonatomic, strong) NSMutableArray* dataSet;
@property (nonatomic, assign) NSInteger messageCount;
@property (nonatomic, strong) UserRequest* userRequest;

@end

#endif
