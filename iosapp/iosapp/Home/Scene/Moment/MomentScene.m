//
// Created by Simpson Du on 1/07/15.
// Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentScene.h"
#import "MomentListSceneModel.h"

@interface MomentScene()

@property (strong, nonatomic) MomentListSceneModel* momentListSceneModel;

@end

@implementation MomentScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.momentListSceneModel = [MomentListSceneModel SceneModel];
    self.momentListSceneModel.request.requestNeedActive = YES;
}

@end