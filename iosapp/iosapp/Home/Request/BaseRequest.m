//
//  BaseRequest.m
//  iosapp
//
//  Created by Simpson Du on 1/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest

- (void)loadRequest {
    [super loadRequest];
    self.SCHEME = @"https";
    self.HOST = @"api.parse.com";
    self.needCheckCode = NO;
    self.httpHeaderFields = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                              @"X-Parse-Application-Id": @"hJSBmj3YSXBuZkpXIPuFbR3nZiIZWr0uNfCFBXLl",
                                                                              @"X-Parse-REST-API-Key": @"bLKzd37O5lF6o11FdQ2q0NwQferhjEEvIXFVxEcA"
                                                                              }];
}

- (void)onRequest:(void (^)())successHandler
            error:(void (^)(NSError* error))errorHandler {
    @weakify(self)
    [[RACObserve(self, state)
      filter:^BOOL(NSNumber* state) {
          @strongify(self)
          if (self.failed && self.error) {
              if (errorHandler) {
                  errorHandler(self.error);
              }
              return NO;
          }
          return self.succeed;
      }]
     subscribeNext:^(NSNumber* state) {
         @strongify(self)
         NSError* error = [self outputHandler:self.output];
         if (error) {
             if (errorHandler) {
                 errorHandler(error);
             }
             return;
         }
         if (successHandler) {
             successHandler();
         }
     }];
}

- (NSError*)outputHandler:(NSDictionary* )output {
    return nil;
}

- (void)send {
    self.requestNeedActive = YES;
}

@end
