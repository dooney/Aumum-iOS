//
//  ChatSceneModel.m
//  iosapp
//
//  Created by Administrator on 12/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ChatSceneModel.h"

@implementation ChatSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self);
    self.userRequest = [UserRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.userRequest];
    }];
}

- (void)onUserRequest:(void (^)(User* user))successHandler
                error:(void (^)(NSError* error))errorHandler {
    @weakify(self)
    [[RACObserve(self.userRequest, state)
      filter:^BOOL(NSNumber* state) {
          @strongify(self)
          if (self.userRequest.failed && self.userRequest.error) {
              if (errorHandler) {
                  errorHandler(self.userRequest.error);
              }
              return NO;
          }
          return self.userRequest.succeed;
      }]
     subscribeNext:^(NSNumber* state) {
         @strongify(self)
         NSError* error;
         self.user = [[User alloc] initWithDictionary:self.userRequest.output error:&error];
         if (error) {
             if (errorHandler) {
                 errorHandler(error);
             }
             return;
         }
         if (successHandler) {
             successHandler(self.user);
         }
     }];
}

@end
