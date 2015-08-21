//
//  ContactListSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 20/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_ContactListSceneModel_h
#define iosapp_ContactListSceneModel_h

#import "BaseSceneModel.h"
#import "UserListRequest.h"

@interface ContactListSceneModel : BaseSceneModel

@property (nonatomic, strong) NSMutableArray* contactList;
@property (nonatomic, strong) NSMutableArray* sectionTitles;
@property (nonatomic, strong) UserListRequest* userListRequest;

@end

#endif
