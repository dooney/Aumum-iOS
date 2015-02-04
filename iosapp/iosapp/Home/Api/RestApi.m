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

// Demo
#define PARSE_APP_ID  @"hJSBmj3YSXBuZkpXIPuFbR3nZiIZWr0uNfCFBXLl"
#define PARSE_API_KEY @"bLKzd37O5lF6o11FdQ2q0NwQferhjEEvIXFVxEcA"

// URL
#define PARTY_URL @"https://api.parse.com/1/classes/Parties"

+(void) initRequestHeaders {
    [[JSONHTTPClient requestHeaders] setValue:PARSE_APP_ID forKey:@"X-Parse-Application-Id"];
    [[JSONHTTPClient requestHeaders] setValue:PARSE_API_KEY forKey:@"X-Parse-REST-API-Key"];
}

+(void) get:(NSString* )url
     params:(NSDictionary* )params
     finish:(void (^)(NSDictionary* data))finishHandler
      error:(void (^)(NSString* error))errorHandler {
    [RestApi initRequestHeaders];
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
    [RestApi get:PARTY_URL params:nil finish:finishHandler error:errorHandler];
}

@end
