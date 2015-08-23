//
//  NotificationScene.m
//  iosapp
//
//  Created by Simpson Du on 1/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "NotificationScene.h"
#import "UIView+FLKAutoLayout.h"
#import "MomentNotificationCell.h"
#import "ContactNotificationCell.h"
#import "NotificationListSceneModel.h"
#import "Notification.h"
#import "URLManager.h"

@interface NotificationScene()<UITableViewDelegate, UITableViewDataSource, INotificationCellDelegate>

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
    [self.tableView registerClass:[MomentNotificationCell class] forCellReuseIdentifier:@"MomentNotificationCell"];
    [self.tableView registerClass:[ContactNotificationCell class] forCellReuseIdentifier:@"ContactNotificationCell"];
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
    Notification* notification = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    switch (notification.type) {
        case LIKE_MOMENT:
        case COMMENT_MOMENT: {
            MomentNotificationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MomentNotificationCell" forIndexPath:indexPath];
            [cell reloadData:notification];
            return cell;
        }
            break;
        case NEW_CONTACT: {
            ContactNotificationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ContactNotificationCell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell reloadData:notification];
            return cell;
        }
            break;
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Notification* notification = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    notification.isRead = YES;
    [notification save];
    NSString* url;
    if (notification.momentId.length > 0) {
        url = [NSString stringWithFormat:@"iosapp://moment?momentId=%@", notification.momentId];
    } else {
        url = [NSString stringWithFormat:@"iosapp://user?userId=%@", notification.userId];
    }
    [URLManager pushURLString:url animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"decreaseNotificationUnread" object:nil];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)newNotification:(NSNotification*)notif {
    dispatch_async(dispatch_get_main_queue(),^{
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
    });
}

- (void)didPressAcceptButton:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Notification* notification = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    [notification deleteSelf];
    [self.sceneModel.dataSet removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
