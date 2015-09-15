//
//  NewMomentRequest.h
//  iosapp
//
//  Created by Simpson Du on 29/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_NewMomentRequest_h
#define iosapp_NewMomentRequest_h

#import "BaseRequest.h"
#import "Moment.h"

@interface NewMomentRequest : BaseRequest

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* userId;
@property (nonatomic, strong)NSString* imageUrl;
@property (nonatomic, strong)NSString* text;
@property (nonatomic, assign)CGFloat ratio;
@property (nonatomic, strong)NSMutableArray* tags;

- (void)send:(Moment*)moment;

@end

#endif
