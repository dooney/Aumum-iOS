//
//  NewMomentSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 31/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_NewMomentSceneModel_h
#define iosapp_NewMomentSceneModel_h

#import "BaseSceneModel.h"
#import "NewMomentRequest.h"
#import "TagListRequest.h"
#import "BatchRequest.h"

@interface NewMomentSceneModel : BaseSceneModel

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NewMomentRequest* request;
@property (nonatomic, strong) TagListRequest* tagListRequest;
@property (nonatomic, strong) BatchRequest* batchRequest;

@end

#endif
