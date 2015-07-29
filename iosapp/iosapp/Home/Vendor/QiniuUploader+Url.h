//
//  QiniuUploader+Url.h
//  iosapp
//
//  Created by Simpson Du on 28/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_QiniuUploader_Url_h
#define iosapp_QiniuUploader_Url_h

#import "QiniuUploader.h"

@interface QiniuUploader (Url)

+ (NSString*)getRemoteUrl:(NSString*)key;

@end

#endif
