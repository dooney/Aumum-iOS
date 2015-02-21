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

@property (strong, nonatomic) SceneTableView *tableView;
- (BaseSceneModel*)getSceneModel;

@end

@implementation LoaderScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[SceneTableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    BaseSceneModel* sceneModel = [self getSceneModel];
    [sceneModel loadData];
    
    [self loadHud:self.view];
    [self showHudIndeterminate:@"加载中"];
    [[RACObserve(sceneModel, data)
     filter:^BOOL(NSDictionary* data) {
         return data != nil;
     }]
     subscribeNext:^(NSDictionary* data) {
         [_tableView reloadData];
         [self hideHudSuccess:@"加载成功"];
     }];
}

- (BaseSceneModel*)getSceneModel {
    return nil;
}

@end
