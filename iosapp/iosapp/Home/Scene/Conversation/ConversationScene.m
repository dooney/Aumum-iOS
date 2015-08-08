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
    
    [self addControls];
    [self initSceneModel];
}

- (void)addControls {
    self.tableView = [[SceneTableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.fd_debugLogEnabled = YES;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    [self.tableView registerClass:[ConversationCell class] forCellReuseIdentifier:@"ConversationCell"];
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
    [self.sceneModel.userListByChatIdRequest send:userIdList];
    [self.sceneModel.userListByChatIdRequest onRequest:^() {
        for (Conversation* conversation in self.sceneModel.dataSet) {
            for (User* user in self.sceneModel.userListByChatIdRequest.list.results) {
                if ([conversation.chatId isEqualToString:user.chatId]) {
                    conversation.user = user;
                }
            }
        }
        [self.tableView reloadData];
    } error:^(NSError* error) {
        [self showError:error];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Conversation* conversation = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    ChatScene* chatScene = [[ChatScene alloc] initWithUserId:conversation.user.objectId];
    chatScene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatScene animated:YES];
}

@end
