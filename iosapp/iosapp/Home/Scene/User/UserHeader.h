//
//  UserHeader.h
//  iosapp
//
//  Created by Simpson Du on 14/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UserHeader_h
#define iosapp_UserHeader_h

#import <UIKit/UIKit.h>
#import "UserDetails.h"

@interface UserHeader : UICollectionReusableView

- (void)reloadData:(UserDetails*)user;

@end

#endif
