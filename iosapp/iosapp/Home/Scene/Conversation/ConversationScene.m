//
//  ConversationScene.m
//  iosapp
//
//  Created by Simpson Du on 14/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ConversationScene.h"
#import "ConversationListSceneModel.h"
#import "UIView+FLKAutoLayout.h"
#import "ConversationCell.h"
#import "Conversation.h"
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
    [self.sceneModel.userByIdRequest onRequest:^{
        dispatch_async(dispatch_get_main_queue(),^{
            [self loadConversationForUser:self.sceneModel.userByIdRequest.user];
        });
    } error:^(NSError *error) {
    }];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newMessage:)
                                                 name:@"newMessage"
                                               object:nil];
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
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Conversation* conversation = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    ChatScene* chatScene = [[ChatScene alloc] initWithUserId:conversation.user.objectId];
    chatScene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatScene animated:YES];
    if (conversation.unreadCount > 0) {
        conversation.unreadCount = 0;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)newMessage:(NSNotification*)notif {
    User* user = nil;
    EMMessage* message = notif.object;
    EMConversation* emConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:message.conversationChatter conversationType:eConversationTypeChat];
    for (int i = 0; i < self.sceneModel.dataSet.count; i++) {
        Conversation* item = [self.sceneModel.dataSet objectAtIndex:i];
        if ([item.chatId isEqualToString:message.conversationChatter]) {
            Conversation* conversation = [self.sceneModel.dataSet objectAtIndex:i];
            if (i == 0) {
                id<IEMMessageBody> messageBody = [emConversation.latestMessage.messageBodies firstObject];
                conversation.latestMessage = ((EMTextMessageBody *)messageBody).text;
                conversation.latestTimestamp = ((EMTextMessageBody *)messageBody).message.timestamp;
                conversation.unreadCount = emConversation.unreadMessagesCount;
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
                return;
            } else {
                user = conversation.user;
                [self.sceneModel.dataSet removeObjectAtIndex:i];
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                });
                break;
            }
        }
    }
    if (user) {
        [self loadConversationForUser:user];
    } else {
        [self.sceneModel.userByIdRequest getByChatId:message.conversationChatter];
    }
}

- (void)loadConversationForUser:(User*)user {
    EMConversation* emConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:user.chatId conversationType:eConversationTypeChat];
    Conversation* conversation = [[Conversation alloc] initWithEMConversation:emConversation];
    conversation.user = user;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationTop;
    UITableViewScrollPosition scrollPosition = UITableViewScrollPositionTop;
    [self.tableView beginUpdates];
    [self.sceneModel.dataSet insertObject:conversation atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
