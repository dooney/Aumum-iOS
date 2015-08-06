//
//  UpdateMomentRequest.h
//  iosapp
//
//  Created by Simpson Du on 6/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_UpdateMomentRequest_h
#define iosapp_UpdateMomentRequest_h

#import "BaseRequest.h"

@interface UpdateMomentRequest : BaseRequest

@property (nonatomic, strong) NSDictionary* likes;

- (void)addLike:(NSString*)momentId userId:(NSString*)userId;
- (void)removeLike:(NSString*)momentId userId:(NSString*)userId;

@end

#endif
