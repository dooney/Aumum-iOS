//
//  RestApi.m
//  iosapp
//
//  Created by Simpson Du on 3/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "RestApi.h"
#import "JSONHttpClient.h"
#import "GCDQueue.h"

@interface RestApi ()

+(void) getPartyList:(void (^)(NSDictionary* data))finishHandler
               error:(void (^)(NSString* error))errorHandler;

@end

@implementation RestApi

+(void) get:(NSString* )url
     params:(NSDictionary* )params
     finish:(void (^)(NSDictionary* data))finishHandler
      error:(void (^)(NSString* error))errorHandler {
    [JSONHTTPClient getJSONFromURLWithString:url
                                      params:params
                                  completion:^(NSDictionary* json, JSONModelError *err) {
                                      if (err) {
                                          if (errorHandler) {
                                              [[GCDQueue mainQueue] queueBlock:^{
                                                  errorHandler([err localizedDescription]);
                                              }];
                                          }
                                      } else {
                                          if (finishHandler) {
                                              [[GCDQueue mainQueue] queueBlock:^{
                                                  finishHandler(json);
                                              }];
                                          }
                                      }
                                  }];
}

+(void) getPartyList:(void (^)(NSDictionary* data))finishHandler
               error:(void (^)(NSString* error))errorHandler {
    NSString* url = @"http://7tsz2s.com1.z0.glb.clouddn.com/lists.txt";
    [RestApi get:url params:nil finish:finishHandler error:errorHandler];
}

@end
