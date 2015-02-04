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
- (void)showView;

@end

@implementation LoaderScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sceneModel = [self getSceneModel];
    [self.sceneModel loadData];
    
    [self loadHud:self.view];
    [self showHudIndeterminate:@"加载中"];
    [[RACObserve(self.sceneModel, data)
     filter:^BOOL(NSDictionary* data) {
         return data != nil;
     }]
     subscribeNext:^(NSDictionary* data) {
         [self showView];
         [self hideHudSuccess:@"加载成功"];
     }];
}

- (BaseSceneModel*)getSceneModel {
    return nil;
}

- (void)showView {
}

@end
