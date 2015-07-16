//
//  ChatScene.m
//  iosapp
//
//  Created by Administrator on 11/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ChatScene.h"
#import "ChatSceneModel.h"
#import "ReactiveCocoa.h"
#import "EaseMob.h"
#import "JSQMessages.h"
#import "ChatSendHelper.h"
#import "NSDate+Category.h"
#import "UIImage+EasyExtend.h"

@interface ChatScene()<IChatManagerDelegate>
{
    NSString* _userId;
    EMConversation* _conversation;
    JSQMessagesBubbleImage* _outgoingBubbleImageData;
    JSQMessagesBubbleImage* _incomingBubbleImageData;
    NSDictionary* _avatars;
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
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_userId conversationType:eConversationTypeChat];
    [_conversation markAllMessagesAsRead:YES];
    
    [self initSceneModel];
    
    self.senderId = self.sceneModel.profile.chatId;
    self.senderDisplayName = self.sceneModel.profile.screenName;
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    _outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    _incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    JSQMessagesAvatarImage* userAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithUrl:self.sceneModel.user.avatarUrl]
                                                                                    diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    JSQMessagesAvatarImage* profileAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithUrl:self.sceneModel.profile.avatarUrl]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    _avatars = @{
                 self.sceneModel.user.chatId:userAvatar,
                 self.sceneModel.profile.chatId:profileAvatar
                 };
}

- (void)dealloc {
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)initSceneModel {
    self.sceneModel = [ChatSceneModel SceneModel];
    
    self.sceneModel.profile = [Profile get];
    self.sceneModel.user = [User getById:_userId];
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:20 append:NO];
}

- (void)loadMoreMessagesFrom:(long long)timestamp count:(NSInteger)count append:(BOOL)append {
    NSArray* messages = [_conversation loadNumbersOfMessages:count before:timestamp];
    if ([messages count] > 0) {
        NSMutableArray* messageList = [NSMutableArray array];
        if ([messages count] > 0) {
            for (EMMessage* message in messages) {
                JSQMessage* jsqMessage = [self getMessage:message];
                [messageList addObject:jsqMessage];
            }
        }
        if (append) {
            [self.sceneModel.dataSet insertObjects:messageList atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messageList count])]];
        } else {
            self.sceneModel.dataSet = [messageList mutableCopy];
        }
    }
}

- (JSQMessage *)getMessage:(EMMessage *)message {
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    return [[JSQMessage alloc] initWithSenderId:message.from
                              senderDisplayName:self.sceneModel.user.screenName
                                           date:[NSDate dateWithTimeIntervalInMilliSecondSince1970:message.timestamp]
                                           text:((EMTextMessageBody*)messageBody).text];
}

#pragma mark - IChatManagerDelegate
- (void)didReceiveMessage:(EMMessage *)message {
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        JSQMessage* jsqMessage = [self getMessage:message];
        [self.sceneModel.dataSet addObject:jsqMessage];
        [self finishReceivingMessageAnimated:YES];
    }
}

#pragma mark - send message

-(void)sendTextMessage:(NSString *)textMessage {
    [ChatSendHelper sendTextMessageWithString:textMessage
                                   toUsername:_conversation.chatter
                                  messageType:eMessageTypeChat
                            requireEncryption:NO
                                          ext:nil];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.sceneModel.dataSet objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.sceneModel.dataSet objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return _outgoingBubbleImageData;
    }
    return _incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.sceneModel.dataSet objectAtIndex:indexPath.item];
    return [_avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.sceneModel.dataSet objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.sceneModel.dataSet objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.sceneModel.dataSet objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sceneModel.dataSet count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self.sceneModel.dataSet objectAtIndex:indexPath.item];
    if (!msg.isMediaMessage) {
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        } else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    return cell;
}

#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(customAction:)) {
        return YES;
    }
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender {
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *currentMessage = [self.sceneModel.dataSet objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.sceneModel.dataSet objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    JSQMessage *jsqMessage = [[JSQMessage alloc] initWithSenderId:senderId
                                                senderDisplayName:senderDisplayName
                                                             date:date
                                                             text:text];
    [self.sceneModel.dataSet addObject:jsqMessage];
    [self finishSendingMessageAnimated:YES];
    
    [self sendTextMessage:text];
}

- (void)didPressAccessoryButton:(UIButton *)sender {
}

@end
