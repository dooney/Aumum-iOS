//
//  QiniuUploader+Url.m
//  iosapp
//
//  Created by Simpson Du on 28/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "QiniuUploader+Url.h"

@implementation QiniuUploader (Url)

+ (NSString*)getBaseUrl {
    return @"http://7sbnoz.com5.z0.glb.clouddn.com/";
}

+ (NSString*)getRemoteUrl:(NSString*)key {
    return [[self getBaseUrl] stringByAppendingString:key];
}

@end
