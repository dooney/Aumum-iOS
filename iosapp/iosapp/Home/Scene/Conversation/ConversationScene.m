//
//  ConversationScene.m
//  iosapp
//
//  Created by Simpson Du on 14/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ConversationScene.h"
#import "SceneTableView.h"
#import "ConversationListSceneModel.h"
#import "UIView+FLKAutoLayout.h"
#import "UIViewController+MBHud.h"
#import "ConversationCell.h"
#import "Conversation.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "EaseMob.h"
#import "ChatScene.h"
#import "URLManager.h"

@interface ConversationScene()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ConversationListSceneModel* sceneModel;
@property (strong, nonatomic) SceneTableView* tableView;

@end

@implementation ConversationScene

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
    [self.tableView registerClass:[ConversationCell class] forCellReuseIdentifier:@"ConversationCell"];
    
    [self loadHud:self.view];
}

- (void)initSceneModel {
    self.sceneModel = [ConversationListSceneModel SceneModel];
    
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    NSArray* conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray* userIdList = [NSMutableArray array];
    for (EMConversation* emConversation in conversations) {
        if (![userIdList containsObject:emConversation.chatter]) {
            [userIdList addObject:emConversation.chatter];
        }
        Conversation* conversation = [[Conversation alloc] initWithEMConversation:emConversation];
        if (!self.sceneModel.dataSet) {
            self.sceneModel.dataSet = [NSMutableArray array];
        }
        [self.sceneModel.dataSet addObject:conversation];
    }
    [self.sceneModel.userListByChatIdRequest setChatIdList:userIdList];
    self.sceneModel.userListByChatIdRequest.requestNeedActive = YES;
    [self.sceneModel.userListByChatIdRequest onRequest:^() {
        for (Conversation* conversation in self.sceneModel.dataSet) {
            for (User* user in self.sceneModel.userListByChatIdRequest.list.results) {
                if ([conversation.chatId isEqualToString:user.chatId]) {
                    conversation.user = user;
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
    ConversationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCell" forIndexPath:indexPath];
    Conversation* conversation = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    [cell reloadData:conversation];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"ConversationCell" cacheByIndexPath:indexPath configuration:^(ConversationCell *cell) {
        Conversation* conversation = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
        [cell reloadData:conversation];
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
    Conversation* conversation = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    ChatScene* chatScene = [[ChatScene alloc] initWithUserId:conversation.user.objectId];
    [self.navigationController presentViewController:chatScene animated:YES completion:nil];
}

@end
