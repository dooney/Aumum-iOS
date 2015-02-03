//
//  LoaderScene.m
//  iosapp
//
//  Created by Simpson Du on 2/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "LoaderScene.h"
#import "BaseSceneModel.h"
#import "UIViewController+MBHud.h"

@interface LoaderScene ()

- (BaseSceneModel*)getSceneModel;

@end

@implementation LoaderScene

- (void)viewDidLoad {
    [super viewDidLoad];
    BaseSceneModel* sceneModel = [self getSceneModel];
    [sceneModel loadData];
    [self loadHud:self.view];
    [self showHudIndeterminate:@"加载中"];
    [[RACObserve(sceneModel, data)
      filter:^BOOL(NSDictionary *data) {
          return !data;
      }]
     subscribeNext:^(NSDictionary *data) {
         [self hideHudSuccess:@"加载成功"];
     }];
}

@end
