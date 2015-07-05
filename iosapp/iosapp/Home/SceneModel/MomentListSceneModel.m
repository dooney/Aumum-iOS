//
//  MomentListSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 1/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentListSceneModel.h"
#import "MomentList.h"
#import "UserList.h"

@implementation MomentListSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self);
    self.request = [MomentListRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
    
    self.userListRequest = [UserListRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.userListRequest];
    }];
    
    [[RACObserve(self.request, state)
      filter:^BOOL(NSNumber* state) {
          @strongify(self)
          return self.request.succeed;
      }]
     subscribeNext:^(NSNumber* state) {
         @strongify(self)
         NSError* error;
         self.list = [[MomentList alloc] initWithDictionary:self.request.output error:&error];
     }];
    
    [[RACObserve(self, list)
      filter:^BOOL(MomentList* list) {
          return list != nil && list.results.count > 0;
      }]
     subscribeNext:^(MomentList* list) {
         @strongify(self)
         NSMutableArray* userIdList = [NSMutableArray array];
         for (Moment* moment in list.results) {
             if (![userIdList containsObject:moment.userId]) {
                 [userIdList addObject:moment.userId];
             }
         }
         [self.userListRequest setUserIdList:userIdList];
         self.userListRequest.requestNeedActive = YES;
     }];
    
    [[RACObserve(self.userListRequest, state)
      filter:^BOOL(NSNumber* state) {
          @strongify(self)
          return self.userListRequest.succeed;
      }]
     subscribeNext:^(NSNumber* state) {
         @strongify(self)
         NSError* error;
         self.userList = [[UserList alloc] initWithDictionary:self.userListRequest.output error:&error];
     }];
}

@end
