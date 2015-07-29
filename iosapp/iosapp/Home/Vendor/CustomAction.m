//
//  CustomAction.m
//  iosapp
//
//  Created by Simpson Du on 29/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "CustomAction.h"

@implementation CustomAction

- (AFHTTPRequestOperation *)Send:(Request *)msg {
    if ([msg.METHOD isEqualToString:@"GET"]) {
        return [super Send:msg];
    } else {
        NSString *url = @"";
        NSDictionary *requestParams = nil;
        if (msg.STATICPATH.isNotEmpty) {
            url = msg.STATICPATH;
        } else {
            if (msg.SCHEME.isNotEmpty && msg.HOST.isNotEmpty) {
                url = [NSString stringWithFormat:@"%@://%@%@",msg.SCHEME,msg.HOST,msg.PATH];
            }
            if (msg.appendPathInfo.isNotEmpty) {
                url = [url stringByAppendingString:msg.appendPathInfo];
            } else {
                requestParams = msg.requestParams;
            }
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        if (msg.httpHeaderFields.isNotEmpty) {
            [msg.httpHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
                [manager.requestSerializer setValue:value forHTTPHeaderField:key];
            }];
        }
        if (msg.timeoutInterval != 0) {
            manager.requestSerializer.timeoutInterval = msg.timeoutInterval;
        }
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        if (msg.acceptableContentTypes.isNotEmpty) {
            manager.responseSerializer.acceptableContentTypes = msg.acceptableContentTypes;
        }
        msg.state = RequestStateSending;
        if([self.aDelegaete respondsToSelector:@selector(handleActionMsg:)]){
            [self.aDelegaete handleActionMsg:msg];
        }
        @weakify(msg,self);
        if ([msg.METHOD isEqualToString:@"POST"]) {
            msg.op = [manager POST:url parameters:requestParams success:^(AFHTTPRequestOperation *operation, NSDictionary* jsonObject) {
                @strongify(msg,self);
                msg.output = jsonObject;
                [self success:msg];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                @strongify(msg,self);
                msg.error = error;
                [self failed:msg];
            }];
            msg.url = msg.op.request.URL;
        } else if ([msg.METHOD isEqualToString:@"PUT"]) {
            msg.op = [manager PUT:url parameters:requestParams success:^(AFHTTPRequestOperation *operation, NSDictionary* jsonObject) {
                @strongify(msg,self);
                msg.output = jsonObject;
                [self success:msg];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                @strongify(msg,self);
                msg.error = error;
                [self failed:msg];
            }];
            msg.url = msg.op.request.URL;
        }
        return msg.op;
    }
}

@end
