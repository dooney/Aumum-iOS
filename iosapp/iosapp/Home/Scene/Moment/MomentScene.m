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

@interface MomentScene()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MomentListSceneModel* momentListSceneModel;
@property (strong, nonatomic) SceneTableView* tableView;

@end

@implementation MomentScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[SceneTableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    [self.tableView registerClass:[MomentCell class] forCellReuseIdentifier:@"MomentCell"];
    
    [self loadHud:self.view];
    
    self.momentListSceneModel = [MomentListSceneModel SceneModel];
    self.momentListSceneModel.request.requestNeedActive = YES;
    
    @weakify(self);
    [[RACObserve(self.momentListSceneModel, list)
     filter:^BOOL(MomentList* list) {
         return list != nil;
     }]
     subscribeNext:^(MomentList* list) {
         @strongify(self);
         if (self.momentListSceneModel.dataSet == nil) {
             self.momentListSceneModel.dataSet = [NSMutableArray array];
         }
         if ([list.results count] > 0) {
             [self.momentListSceneModel.dataSet addObjectsFromArray:list.results];
             [self.tableView reloadData];
         }
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.momentListSceneModel.dataSet.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MomentCell" forIndexPath:indexPath];
    Moment* moment = [self.momentListSceneModel.dataSet objectAtIndex:indexPath.row];
    [cell refresh:moment];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end