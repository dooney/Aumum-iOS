//
//  ChatSceneModel.h
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ChatSceneModel_h
#define iosapp_ChatSceneModel_h

#import "BaseSceneModel.h"
#import "Profile.h"
#import "User.h"

@interface ChatSceneModel : BaseSceneModel

@property (nonatomic, strong) NSMutableArray* dataSet;
@property (nonatomic, strong) Profile* profile;
@property (nonatomic, strong) User* user;

@end

#endif
