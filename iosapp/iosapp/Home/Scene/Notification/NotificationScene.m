//
//  NotificationScene.m
//  iosapp
//
//  Created by Simpson Du on 1/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "NotificationScene.h"
#import "UIView+FLKAutoLayout.h"
#import "NotificationCell.h"
#import "NotificationListSceneModel.h"
#import "Notification.h"
#import "MomentDetailsScene.h"
#import "RDNavigationController.h"

@interface NotificationScene()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NotificationListSceneModel* sceneModel;
@property (strong, nonatomic) SceneTableView* tableView;

@end

@implementation NotificationScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addControls];
    [self initSceneModel];
    [self initNotification];
}

- (void)addControls {
    self.tableView = [[SceneTableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    [self.tableView registerClass:[NotificationCell class] forCellReuseIdentifier:@"NotificationCell"];
}

- (void)initSceneModel {
    self.sceneModel = [NotificationListSceneModel SceneModel];
    self.sceneModel.dataSet = [NSMutableArray arrayWithArray:[Notification findAll]];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newNotification:)
                                                 name:@"newNotification"
                                               object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.dataSet.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    Notification* notification = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    [cell reloadData:notification];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Notification* notification = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    if (notification.momentId) {
        MomentDetailsScene* scene = [[MomentDetailsScene alloc] initWithMomentId:notification.momentId promptInput:NO];
        RDNavigationController* navigationController = [[RDNavigationController alloc] initWithRootViewController:scene];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:navigationController animated:YES completion:^{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        });
    }
    notification.isRead = YES;
    [notification save];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"decreaseNotificationUnread" object:nil];
}

- (void)newNotification:(NSNotification*)notif {
    Notification* notification = notif.object;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationTop;
    UITableViewScrollPosition scrollPosition = UITableViewScrollPositionTop;
    [self.tableView beginUpdates];
    [self.sceneModel.dataSet insertObject:notification atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
