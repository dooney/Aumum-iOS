//
//  UserSectionHeader.h
//  iosapp
//
//  Created by Simpson Du on 17/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UserSectionHeader_h
#define iosapp_UserSectionHeader_h

#import <UIKit/UIKit.h>
#import "UserDetails.h"

@interface UserSectionHeader : UICollectionReusableView

- (void)reloadUser:(UserDetails*)user;
- (void)reloadProfile:(UserDetails*)user;

@end

#endif
