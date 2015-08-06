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

@interface TabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) RDNavigationController* momentNavController;
@property (nonatomic, strong) RDNavigationController* conversationNavController;
@property (nonatomic, strong) RDNavigationController* discoverNavController;
@property (nonatomic, strong) RDNavigationController* notificationNavController;
@property (nonatomic, strong) RDNavigationController* profileNavController;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent= NO;
    
    self.momentNavController = [[RDNavigationController alloc] initWithRootViewController:[[MomentScene alloc] init]];
    [self.momentNavController.tabBarItem setTitle:NSLocalizedString(@"label.home", nil)];
    self.momentNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7HomeOutline" fromFont:ionIcons]
                                                               fontName:ionIcons iconColor:[UIColor blackColor] iconSize:36];
    
    self.conversationNavController = [[RDNavigationController alloc] initWithRootViewController:[[ConversationScene alloc] init]];
    [self.conversationNavController.tabBarItem setTitle:NSLocalizedString(@"label.conversation", nil)];
    self.conversationNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7ChatbubbleOutline" fromFont:ionIcons]
                                                                     fontName:ionIcons iconColor:[UIColor blackColor] iconSize:36];
    
    self.discoverNavController = [[RDNavigationController alloc] initWithRootViewController:[[DiscoverScene alloc] init]];
    [self.discoverNavController.tabBarItem setTitle:NSLocalizedString(@"label.discover", nil)];
    self.discoverNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7Search" fromFont:ionIcons]
                                                                 fontName:ionIcons iconColor:[UIColor blackColor] iconSize:36];
    
    self.notificationNavController = [[RDNavigationController alloc] initWithRootViewController:[[NotificationScene alloc] init]];
    [self.notificationNavController.tabBarItem setTitle:NSLocalizedString(@"label.notification", nil)];
    self.notificationNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7BellOutline" fromFont:ionIcons]
                                                                     fontName:ionIcons iconColor:[UIColor blackColor] iconSize:36];
    
    self.profileNavController = [[RDNavigationController alloc] initWithRootViewController:[[ProfileScene alloc] init]];
    [self.profileNavController.tabBarItem setTitle:NSLocalizedString(@"label.profile", nil)];
    self.profileNavController.tabBarItem.image = [IconFont imageWithIcon:[IconFont icon:@"ios7PersonOutline" fromFont:ionIcons]
                                                                fontName:ionIcons iconColor:[UIColor blackColor] iconSize:36];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            self.momentNavController,
                            self.conversationNavController,
                            self.discoverNavController,
                            self.notificationNavController,
                            self.profileNavController,
                            nil];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
