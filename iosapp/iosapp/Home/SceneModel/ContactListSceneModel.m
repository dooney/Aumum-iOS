//
//  ContactListSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 20/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ContactListSceneModel.h"

@implementation ContactListSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    self.contactList = [NSMutableArray array];
    self.sectionTitles = [NSMutableArray array];
    
    @weakify(self);
    self.userListRequest = [UserListRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.userListRequest];
    }];
}
@end
