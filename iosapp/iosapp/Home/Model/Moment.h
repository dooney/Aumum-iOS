//
//  Moment.h
//  iosapp
//
//  Created by Simpson Du on 1/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#ifndef iosapp_Moment_h
#define iosapp_Moment_h

#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import "User.h"

@interface Moment: BaseModel

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* createdAt;
@property (nonatomic, strong)NSString* userId;
@property (nonatomic, strong)NSString* imageUrl;
@property (nonatomic, strong)NSString<Optional>* text;
@property (nonatomic, assign)CGFloat ratio;
@property (nonatomic, strong)User<Ignore>* user;
@property (nonatomic, strong)NSMutableArray<Optional>* likes;

- (id)init:(NSString*)userId imageUrl:(NSString*)imageUrl text:(NSString*)text ratio:(CGFloat)ratio;
- (BOOL)isLiked:(NSString*)userId;

@end

@protocol Moment

@end

#endif
