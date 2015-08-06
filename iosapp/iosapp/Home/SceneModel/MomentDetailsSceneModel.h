//
//  MomentDetailsSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 3/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_MomentDetailsSceneModel_h
#define iosapp_MomentDetailsSceneModel_h

#import "BaseSceneModel.h"
#import "Moment.h"
#import "CommentListRequest.h"
#import "UserListRequest.h"
#import "NewCommentRequest.h"

@interface MomentDetailsSceneModel : BaseSceneModel

@property (nonatomic, strong) Moment* moment;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) CommentListRequest* request;
@property (nonatomic, strong) NSMutableArray* comments;
@property (nonatomic, strong) UserListRequest* userListRequest;
@property (nonatomic, strong) NewCommentRequest* commentRequest;

@end

#endif
