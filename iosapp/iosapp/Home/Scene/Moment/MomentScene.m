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
    
    [self addControls];
    [self initSceneModel];
}

- (void)addControls {
    self.tableView = [[SceneTableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    [self.sceneModel.request onRequest:^() {
        if (self.sceneModel.request.list &&
            self.sceneModel.request.list.results.count > 0) {
            if (!self.sceneModel.dataSet) {
                self.sceneModel.dataSet = [NSMutableArray array];
            }
            [self.sceneModel.dataSet addObjectsFromArray:self.sceneModel.request.list.results];
            NSMutableArray* userIdList = [NSMutableArray array];
            for (Moment* moment in self.sceneModel.request.list.results) {
                if (![userIdList containsObject:moment.userId]) {
                    [userIdList addObject:moment.userId];
                }
            }
            [self.sceneModel.userListRequest send:userIdList];
        }
    } error:^(NSError* error) {
        [self hideHudFailed:error.localizedDescription];
    }];
    
    [self.sceneModel.userListRequest onRequest:^() {
        for (Moment* moment in self.sceneModel.dataSet) {
            for (User* user in self.sceneModel.userListRequest.list.results) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end