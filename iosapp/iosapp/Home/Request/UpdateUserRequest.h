//
//  UpdateUserRequest.h
//  iosapp
//
//  Created by Simpson Du on 28/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UpdateUserRequest_h
#define iosapp_UpdateUserRequest_h

#import "BaseRequest.h"

@interface UpdateUserRequest : BaseRequest

@property (nonatomic, strong)NSString* screenName;
@property (nonatomic, strong)NSString* avatarUrl;

- (void)send:(NSString*)userId screenName:(NSString*)screenName avatarUrl:(NSString*)avatarUrl;

@end

#endif
