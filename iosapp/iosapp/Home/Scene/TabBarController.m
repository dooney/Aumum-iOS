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
#import "ProfileScene.h"

@interface TabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) RDNavigationController* momentNavController;
@property (nonatomic, strong) RDNavigationController* profileNavController;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent= NO;
    
    self.momentNavController = [[RDNavigationController alloc] initWithRootViewController:[[MomentScene alloc] init]];
    [self.momentNavController.tabBarItem setTitle:@"Home"];
    
    self.profileNavController = [[RDNavigationController alloc] initWithRootViewController:[[ProfileScene alloc] init]];
    [self.profileNavController.tabBarItem setTitle:@"Profile"];
    
    self.viewControllers = [NSArray arrayWithObjects:
                            self.momentNavController,
                            self.profileNavController,
                            nil];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
