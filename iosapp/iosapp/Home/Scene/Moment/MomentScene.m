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

@property (strong, nonatomic) MomentListSceneModel* momentListSceneModel;
@property (strong, nonatomic) SceneTableView* tableView;

@end

@implementation MomentScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[SceneTableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.fd_debugLogEnabled = YES;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    [self.tableView registerClass:[MomentCell class] forCellReuseIdentifier:@"MomentCell"];
    
    [self loadHud:self.view];
    
    self.momentListSceneModel = [MomentListSceneModel SceneModel];
    self.momentListSceneModel.request.requestNeedActive = YES;
    
    @weakify(self);
    [[RACObserve(self.momentListSceneModel, list)
     filter:^BOOL(MomentList* list) {
         return list != nil && list.results.count > 0;
     }]
     subscribeNext:^(MomentList* list) {
         @strongify(self)
         if (self.momentListSceneModel.dataSet == nil) {
             self.momentListSceneModel.dataSet = [NSMutableArray array];
         }
         [self.momentListSceneModel.dataSet addObjectsFromArray:list.results];
     }];
    
    [[RACObserve(self.momentListSceneModel, userList)
      filter:^BOOL(UserList* list) {
          return list != nil && list.results.count > 0;
      }]
     subscribeNext:^(UserList* list) {
         @strongify(self)
         for (Moment* moment in self.momentListSceneModel.dataSet) {
             for (User* user in list.results) {
                 if ([moment.userId isEqualToString:user.objectId]) {
                     moment.user = user;
                 }
             }
         }
         [self.tableView reloadData];
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.momentListSceneModel.dataSet.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MomentCell" forIndexPath:indexPath];
    Moment* moment = [self.momentListSceneModel.dataSet objectAtIndex:indexPath.row];
    [cell reload:moment];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"MomentCell" cacheByIndexPath:indexPath configuration:^(MomentCell *cell) {
        Moment* moment = [self.momentListSceneModel.dataSet objectAtIndex:indexPath.row];
        [cell reload:moment];
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