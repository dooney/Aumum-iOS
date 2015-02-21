//
//  PartyScene.m
//  iosapp
//
//  Created by Simpson Du on 2/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "PartyScene.h"
#import "PartySceneModel.h"
#import "Party.h"
#import "PartyCell.h"
#import "UIView+FLKAutoLayout.h"

@interface PartyScene ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) SceneTableView *tableView;
@property (nonatomic, retain) PartySceneModel* sceneModel;

- (BaseSceneModel*)getSceneModel;
- (void)showView;

@end

@implementation PartyScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[SceneTableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubView:self.tableView extend:EXTEND_TOP];
    [self.tableView registerClass:[PartyCell class] forCellReuseIdentifier:@"PartyCell"];
}

- (BaseSceneModel*)getSceneModel {
    _sceneModel = [PartySceneModel sharedInstance];
    return _sceneModel;
}

- (void)showView {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.itemList.results.count;
}

- (PartyCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartyCell" forIndexPath:indexPath];
    Party* party = [self.sceneModel.itemList.results objectAtIndex:indexPath.row];
    cell.textLabel.text = party.title;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

@end
