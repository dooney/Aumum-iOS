//
//  TabBarController.m
//  iosapp
//
//  Created by Simpson Du on 21/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "TabBarController.h"
#import "RDNavigationController.h"
#import "MomentScene.h"
#import "ConversationScene.h"
#import "DiscoverScene.h"
#import "NotificationScene.h"
#import "ProfileScene.h"
#import "Tab.h"
#import "Notification.h"
#import "NSDate+Category.h"
#import "EaseMob.h"

@interface TabBarController ()<UITabBarControllerDelegate, IChatManagerDelegate>

@property (nonatomic, strong) RDNavigationController* homeNavController;
@property (nonatomic, strong) RDNavigationController* chatNavController;
@property (nonatomic, strong) RDNavigationController* discoverNavController;
@property (nonatomic, strong) RDNavigationController* notificationNavController;
@property (nonatomic, strong) RDNavigationController* profileNavController;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent= NO;
    [self initTabBarController];
    [self initNotification];
    [self registerEaseMobNotification];
}

- (void)initTabBarController {
    self.homeNavController = [[RDNavigationController alloc] initWithRootViewController:[[MomentScene alloc] init]];
    [self.homeNavController.tabBarItem setTitle:NSLocalizedString(@"label.home", nil)];
    self.homeNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7Home" fromFont:ionIcons]
                                                             fontName:ionIcons iconColor:[UIColor blackColor] iconSize:30];
    Tab* homeTab = [Tab getById:@"Home"];
    if (homeTab.unread > 0) {
        self.homeNavController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)homeTab.unread];
    }
    
    self.chatNavController = [[RDNavigationController alloc] initWithRootViewController:[[ConversationScene alloc] init]];
    [self.chatNavController.tabBarItem setTitle:NSLocalizedString(@"label.chat", nil)];
    self.chatNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7Chatbubble" fromFont:ionIcons]
                                                             fontName:ionIcons iconColor:[UIColor blackColor] iconSize:30];
    Tab* chatTab = [Tab getById:@"Chat"];
    if (chatTab.unread > 0) {
        self.chatNavController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)chatTab.unread];
    }
    
    self.discoverNavController = [[RDNavigationController alloc] initWithRootViewController:[[DiscoverScene alloc] init]];
    [self.discoverNavController.tabBarItem setTitle:NSLocalizedString(@"label.discover", nil)];
    self.discoverNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7SearchStrong" fromFont:ionIcons]
                                                                 fontName:ionIcons iconColor:[UIColor blackColor] iconSize:30];
    
    self.notificationNavController = [[RDNavigationController alloc] initWithRootViewController:[[NotificationScene alloc] init]];
    [self.notificationNavController.tabBarItem setTitle:NSLocalizedString(@"label.notification", nil)];
    self.notificationNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7Bell" fromFont:ionIcons]
                                                                     fontName:ionIcons iconColor:[UIColor blackColor] iconSize:30];
    Tab* notificationTab = [Tab getById:@"Notification"];
    if (notificationTab.unread > 0) {
        self.notificationNavController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)notificationTab.unread];
    }
    
    self.profileNavController = [[RDNavigationController alloc] initWithRootViewController:[[ProfileScene alloc] init]];
    [self.profileNavController.tabBarItem setTitle:NSLocalizedString(@"label.profile", nil)];
    self.profileNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7Person" fromFont:ionIcons]
                                                                fontName:ionIcons iconColor:[UIColor blackColor] iconSize:30];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            self.homeNavController,
                            self.chatNavController,
                            self.discoverNavController,
                            self.notificationNavController,
                            self.profileNavController,
                            nil];
    self.delegate = self;
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(decreaseNotificationUnread)
                                                 name:@"decreaseNotificationUnread"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetHomeUnread)
                                                 name:@"resetHomeUnread"
                                               object:nil];
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification {
    [self unRegisterEaseMobNotification];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - IChatManagerDelegate
- (void)didReceiveCmdMessage:(EMMessage *)message {
    Notification* notification = [[Notification alloc] init];
    notification.type = [[message.ext valueForKey:@"type"] integerValue];
    notification.createdAt = [NSDate utcNow];
    notification.userId = [message.ext valueForKey:@"userId"];
    notification.screenName = [message.ext valueForKey:@"screenName"];
    notification.avatarUrl = [message.ext valueForKey:@"avatarUrl"];
    notification.momentId = [message.ext valueForKey:@"momentId"];
    notification.imageUrl = [message.ext valueForKey:@"imageUrl"];
    notification.content = [message.ext valueForKey:@"content"];
    [notification save];
    switch (notification.type) {
        case NEW_MOMENT:
            self.homeNavController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self increaseTabUnread:@"Home"]];
            break;
        case LIKE_MOMENT:
        case COMMENT_MOMENT:
        case NEW_CONTACT: {
            self.notificationNavController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self increaseTabUnread:@"Notification"]];
            dispatch_async(dispatch_get_main_queue(),^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newNotification" object:notification];
            });
        }
            break;
        default:
            break;
    }
    return;
}

- (void)didFinishedReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages {
    return;
}

- (void)didReceiveMessage:(EMMessage *)message {
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        self.chatNavController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)[self increaseTabUnread:@"Chat"]];
        dispatch_async(dispatch_get_main_queue(),^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newMessage" object:message];
        });
        return;
    } else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive) {
        return;
    }
}

- (void)didUnreadMessagesCountChanged {
    NSInteger unreadCount = [[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase];
    Tab* tab = [Tab getById:@"Chat"];
    tab.unread = unreadCount;
    [tab save];
    self.chatNavController.tabBarItem.badgeValue = tab.unread > 0 ? [NSString stringWithFormat:@"%ld", (long)tab.unread] : nil;
}

- (NSInteger)increaseTabUnread:(NSString*)tabName {
    Tab* tab = [Tab getById:tabName];
    tab.unread++;
    [tab save];
    return tab.unread;
}

- (void)decreaseNotificationUnread {
    Tab* tab = [Tab getById:@"Notification"];
    if (tab.unread > 0) {
        tab.unread--;
        [tab save];
        self.notificationNavController.tabBarItem.badgeValue = tab.unread > 0 ? [NSString stringWithFormat:@"%ld", (long)tab.unread] : nil;
    }
}

- (void)resetHomeUnread {
    Tab* notificationTab = [Tab getById:@"Home"];
    notificationTab.unread = 0;
    [notificationTab save];
    self.notificationNavController.tabBarItem.badgeValue = nil;
}

@end
