//
//  ChatScene.m
//  iosapp
//
//  Created by Administrator on 11/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ChatScene.h"
#import "ChatSceneModel.h"
#import "TextMessageCell.h"
#import "NSDate+Category.h"
#import "ReactiveCocoa.h"
#import "UIViewController+MBHud.h"
#import "ChatMessage.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ChatScene()<IChatManagerDelegate>
{
    dispatch_queue_t _messageQueue;
    NSString* _userId;
}

@property (nonatomic, strong)ChatSceneModel* sceneModel;

@end

@implementation ChatScene

- (id)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TextMessageCell class] forCellReuseIdentifier:@"TextMessageCell"];
    
    [self.leftButton setImage:[UIImage imageNamed:@"icn_upload"] forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor grayColor]];
    
    [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    
    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editortLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.textInputbar.editortRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 256;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    self.typingIndicatorView.canResignByTouch = YES;
    
    [self loadHud:self.view];
    
    _messageQueue = dispatch_queue_create("com.aumum.iosapp", NULL);
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self initSceneModel];
}

- (void)initSceneModel {
    self.sceneModel = [ChatSceneModel SceneModel];
    self.sceneModel.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_userId conversationType:eConversationTypeChat];
    [self.sceneModel.conversation markAllMessagesAsRead:YES];
    [self.sceneModel.userRequest setUserId:_userId];
    self.sceneModel.userRequest.requestNeedActive = YES;
    [self.sceneModel onUserRequest:^(User *user) {
        long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
        [self loadMoreMessagesFrom:timestamp count:20 append:NO];
    } error:^(NSError *error) {
        [self hideHudFailed:error.localizedDescription];
    }];
    
    @weakify(self)
    [RACObserve(self.sceneModel, dataSet)
     subscribeNext:^(id x) {
         @strongify(self)
         [self.tableView reloadData];
         [self.tableView scrollToRowAtIndexPath:self.sceneModel.scrollTo atScrollPosition:UITableViewScrollPositionTop animated:NO];
     }];
}

- (void)loadMoreMessagesFrom:(long long)timestamp count:(NSInteger)count append:(BOOL)append {
    @weakify(self)
    dispatch_async(_messageQueue, ^{
        @strongify(self)
        NSArray* messages = [self.sceneModel.conversation loadNumbersOfMessages:count before:timestamp];
        if ([messages count] > 0) {
            if (append) {
                [self.sceneModel.messages insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                NSArray* messageList = [self getMessages:messages];
                id model = [self.sceneModel.dataSet firstObject];
                if ([model isKindOfClass:[NSString class]]) {
                    NSString* timestamp = model;
                    [messageList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                        if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model]) {
                            [self.sceneModel.dataSet removeObjectAtIndex:0];
                            *stop = YES;
                        }
                    }];
                }
                self.sceneModel.messageCount = [self.sceneModel.dataSet count];
                [self.sceneModel.dataSet insertObjects:messageList atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messageList count])]];
                self.sceneModel.scrollTo = [NSIndexPath indexPathForRow:[self.sceneModel.dataSet count] - self.sceneModel.messageCount - 1 inSection:0];
                
                EMMessage* latest = [self.sceneModel.messages lastObject];
                self.sceneModel.chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)latest.timestamp];
            } else {
                self.sceneModel.messages = [messages mutableCopy];
                self.sceneModel.dataSet = [[self getMessages:messages] mutableCopy];
                self.sceneModel.scrollTo = [NSIndexPath indexPathForRow:[self.sceneModel.dataSet count] - 1 inSection:0];
            }
        }
    });
}

- (NSArray *)getMessages:(NSArray *)messages {
    NSMutableArray* formatArray = [[NSMutableArray alloc] init];
    if ([messages count] > 0) {
        for (EMMessage* message in messages) {
            NSDate* createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.sceneModel.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.sceneModel.chatTagDate == nil)) {
                [formatArray addObject:[createDate formattedTime]];
                self.sceneModel.chatTagDate = createDate;
            }
            
            ChatMessage* chatMessage = [[ChatMessage alloc] initWithMessage:message];
            chatMessage.user = self.sceneModel.user;
            [formatArray addObject:chatMessage];
        }
    }
    
    return formatArray;
}

- (void)addMessage:(EMMessage *)message {
    [self.sceneModel.messages addObject:message];
    NSArray *messages = [self getMessages:@[ message ]];
    [self.sceneModel.dataSet addObjectsFromArray:messages];
    self.sceneModel.scrollTo = [NSIndexPath indexPathForRow:[self.sceneModel.dataSet count] - 1 inSection:0];
}

#pragma mark - IChatManagerDelegate
- (void)didReceiveMessage:(EMMessage *)message {
    if ([self.sceneModel.conversation.chatter isEqualToString:message.conversationChatter]) {
        [self addMessage:message];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.dataSet.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextMessageCell *cell = (TextMessageCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TextMessageCell"];
    id entity = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    [cell reloadData:entity];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"TextMessageCell" cacheByIndexPath:indexPath configuration:^(TextMessageCell *cell) {
        id entity = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
        [cell reloadData:entity];
    }];
}

@end
