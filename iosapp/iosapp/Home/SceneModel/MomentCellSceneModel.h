
//
//  MomentCellSceneModel.h
//  iosapp
//
//  Created by Simpson Du on 2/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_MomentCellSceneModel_h
#define iosapp_MomentCellSceneModel_h

#import "BaseSceneModel.h"
#import "UpdateMomentRequest.h"
#import "Moment.h"

@interface MomentCellSceneModel : BaseSceneModel

@property (nonatomic, strong)UpdateMomentRequest* request;
@property (nonatomic, strong)Moment* moment;
@property (nonatomic, strong)NSString* userId;

@end

#endif
