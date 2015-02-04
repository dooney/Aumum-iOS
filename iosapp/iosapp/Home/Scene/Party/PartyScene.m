//
//  PartyScene.m
//  iosapp
//
//  Created by Simpson Du on 2/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "PartyScene.h"
#import "PartySceneModel.h"

@interface PartyScene ()

- (BaseSceneModel*)getSceneModel;
- (void)showView;

@end

@implementation PartyScene

- (BaseSceneModel*)getSceneModel {
    return [PartySceneModel sharedInstance];
}

- (void)showView {
    
}

@end
