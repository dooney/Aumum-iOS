//
//  SignInSceneModel.m
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "SignInSceneModel.h"
#import "LoginRequest.h"

@implementation SignInSceneModel

- (void)loadSceneModel {
    [super loadSceneModel];
    
    @weakify(self);
    self.request = [LoginRequest RequestWithBlock:^{
        @strongify(self)
        [self SEND_IQ_ACTION:self.request];
    }];
}

- (void)onRequest:(void (^)(Auth* auth))successHandler
            error:(void (^)(NSError* error))errorHandler
             done:(void (^)())doneHandler {
    @weakify(self)
    [[RACObserve(self.request, state)
      filter:^BOOL(NSNumber* state) {
          @strongify(self)
          if (doneHandler != nil) {
              doneHandler();
          }
          if (self.request.error != nil && errorHandler != nil) {
              errorHandler(self.request.error);
              return NO;
          }
          return self.request.succeed;
      }]
     subscribeNext:^(NSNumber* state) {
         NSError* error;
         self.auth = [[Auth alloc] initWithDictionary:self.request.output error:&error];
         if (error != nil && errorHandler) {
             errorHandler(error);
             return;
         }
         if (successHandler != nil) {
             successHandler(self.auth);
         }
     }];
}

@end
