//
//  UserDetailsRequest.h
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UserDetailsRequest_h
#define iosapp_UserDetailsRequest_h

#import "BaseRequest.h"
#import "UserDetails.h"

@interface UserDetailsRequest : BaseRequest

@property (nonatomic, strong) UserDetails* userDetails;
@property (nonatomic, strong) NSString* keys;

- (void)send:(NSString*)userId;

@end

#endif
