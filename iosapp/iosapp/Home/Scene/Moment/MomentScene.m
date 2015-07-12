//
// Created by Simpson Du on 1/07/15.
// Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentScene.h"
#import "MomentListSceneModel.h"
#import "SceneTableView.h"
#import "UIView+FLKAutoLayout.h"
#import "UIViewController+MBHud.h"
#import "MomentCell.h"
#import "Moment.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface MomentScene()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MomentListSceneModel* sceneModel;
@property (strong, nonatomic) SceneTableView* tableView;

@end

@implementation MomentScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSceneModel];
    
    self.tableView = [[SceneTableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.fd_debugLogEnabled = YES;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    [self.tableView registerClass:[MomentCell class] forCellReuseIdentifier:@"MomentCell"];
    
    [self loadHud:self.view];
}

- (void)initSceneModel {
    self.sceneModel = [MomentListSceneModel SceneModel];
    self.sceneModel.request.requestNeedActive = YES;
    
    [self.sceneModel onRequest:^(MomentList *list) {
        if (self.sceneModel.dataSet == nil) {
            self.sceneModel.dataSet = [NSMutableArray array];
        }
        [self.sceneModel.dataSet addObjectsFromArray:list.results];
        self.sceneModel.userListRequest.requestNeedActive = YES;
    } error:^(NSError* error) {
        [self hideHudFailed:error.localizedDescription];
    }];
    
    [self.sceneModel onUserListRequest:^(UserList *list) {
        for (Moment* moment in self.sceneModel.dataSet) {
            for (User* user in list.results) {
                if ([moment.userId isEqualToString:user.objectId]) {
                    moment.user = user;
                }
            }
        }
        [self hideHud];
        [self.tableView reloadData];
    } error:^(NSError* error) {
        [self hideHudFailed:error.localizedDescription];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.dataSet.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MomentCell" forIndexPath:indexPath];
    Moment* moment = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    [cell reloadData:moment];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"MomentCell" cacheByIndexPath:indexPath configuration:^(MomentCell *cell) {
        Moment* moment = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
        [cell reloadData:moment];
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end