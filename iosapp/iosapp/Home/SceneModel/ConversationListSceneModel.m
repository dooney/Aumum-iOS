//
//  ConversationListSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 14/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ConversationListSceneModel.h"

@implementation ConversationListSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self)
    self.userListByChatIdRequest = [UserListByChatIdRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.userListByChatIdRequest];
    }];
    self.userByIdRequest = [UserByIdRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.userByIdRequest];
    }];
}

@end
