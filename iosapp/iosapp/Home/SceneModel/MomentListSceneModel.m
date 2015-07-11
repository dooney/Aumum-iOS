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
}

- (void)onRequest:(void (^)(MomentList* list))successHandler
            error:(void (^)(NSError* error))errorHandler {
    @weakify(self);
    [[RACObserve(self.request, state)
      filter:^BOOL(NSNumber* state) {
          @strongify(self)
          if (self.request.failed && self.request.error) {
              if (errorHandler) {
                  errorHandler(self.request.error);
              }
              return NO;
          }
          return self.request.succeed;
      }]
     subscribeNext:^(NSNumber* state) {
         @strongify(self)
         NSError* error;
         self.list = [[MomentList alloc] initWithDictionary:self.request.output error:&error];
         if (error) {
             if (errorHandler) {
                 errorHandler(error);
             }
             return;
         }
         if (self.list.results.count > 0) {
             NSMutableArray* userIdList = [NSMutableArray array];
             for (Moment* moment in self.list.results) {
                 if (![userIdList containsObject:moment.userId]) {
                     [userIdList addObject:moment.userId];
                 }
             }
             [self.userListRequest setUserIdList:userIdList];
             if (successHandler) {
                 successHandler(self.list);
             }
         }
     }];
}

- (void)onUserListRequest:(void (^)(UserList* list))successHandler
                    error:(void (^)(NSError* error))errorHandler {
    @weakify(self);
    [[RACObserve(self.userListRequest, state)
      filter:^BOOL(NSNumber* state) {
          @strongify(self)
          if (self.request.failed && self.request.error) {
              if (errorHandler) {
                  errorHandler(self.request.error);
              }
              return NO;
          }
          return self.userListRequest.succeed;
      }]
     subscribeNext:^(NSNumber* state) {
         @strongify(self)
         NSError* error;
         self.userList = [[UserList alloc] initWithDictionary:self.userListRequest.output error:&error];
         if (error) {
             if (errorHandler) {
                 errorHandler(error);
             }
             return;
         }
         if (successHandler) {
             successHandler(self.userList);
         }
     }];
}

@end
