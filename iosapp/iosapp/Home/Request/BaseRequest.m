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
    self.httpHeaderFields = @{
                              @"X-Parse-Application-Id": @"hJSBmj3YSXBuZkpXIPuFbR3nZiIZWr0uNfCFBXLl",
                              @"X-Parse-REST-API-Key": @"bLKzd37O5lF6o11FdQ2q0NwQferhjEEvIXFVxEcA"
                              };
}

@end
