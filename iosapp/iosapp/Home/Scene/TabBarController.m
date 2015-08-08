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

@interface TabBarController ()<UITabBarControllerDelegate>

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
}

- (void)initTabBarController {
    self.homeNavController = [[RDNavigationController alloc] initWithRootViewController:[[MomentScene alloc] init]];
    [self.homeNavController.tabBarItem setTitle:NSLocalizedString(@"label.home", nil)];
    self.homeNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7Home" fromFont:ionIcons]
                                                             fontName:ionIcons iconColor:[UIColor blackColor] iconSize:30];
    
    self.chatNavController = [[RDNavigationController alloc] initWithRootViewController:[[ConversationScene alloc] init]];
    [self.chatNavController.tabBarItem setTitle:NSLocalizedString(@"label.conversation", nil)];
    self.chatNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7Chatbubble" fromFont:ionIcons]
                                                             fontName:ionIcons iconColor:[UIColor blackColor] iconSize:30];
    
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
        self.notificationNavController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", notificationTab.unread];
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
                                             selector:@selector(newCmdMessage:)
                                                 name:@"newCmdMessage"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(decreaseNotificationUnread)
                                                 name:@"decreaseNotificationUnread"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetHomeUnread)
                                                 name:@"resetHomeUnread"
                                               object:nil];
}

- (void)newCmdMessage:(NSNotification *)notif {
    Notification* notification = notif.object;
    switch (notification.type) {
        case NEW_MOMENT:
            self.homeNavController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [self increaseTabUnread:@"Home"]];
            break;
        case LIKE_MOMENT:
        case COMMENT_MOMENT: {
            self.notificationNavController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [self increaseTabUnread:@"Notification"]];
            dispatch_async(dispatch_get_main_queue(),^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newNotification" object:notification];
            });
        }
            break;
        case NEW_CONTACT:
            break;
        default:
            break;
    }
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
        self.notificationNavController.tabBarItem.badgeValue = tab.unread > 0 ? [NSString stringWithFormat:@"%d", tab.unread] : nil;
    }
}

- (void)resetHomeUnread {
    Tab* notificationTab = [Tab getById:@"Home"];
    notificationTab.unread = 0;
    [notificationTab save];
    self.notificationNavController.tabBarItem.badgeValue = nil;
}

@end
