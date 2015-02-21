//
//  TabBarController.m
//  iosapp
//
//  Created by Simpson Du on 21/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "TabBarController.h"
#import "RDNavigationController.h"
#import "PartyScene.h"
#import "AskingScene.h"

@interface TabBarController ()<UITabBarControllerDelegate>

@property(nonatomic,retain)RDNavigationController *partyNavController;
@property(nonatomic,retain)RDNavigationController *askingNavController;
@property(nonatomic,retain)RDNavigationController *chatNavController;
@property(nonatomic,retain)RDNavigationController *contactNavController;
@property(nonatomic,retain)RDNavigationController *profileNavController;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent= NO;
    
    _partyNavController = [[RDNavigationController alloc]initWithRootViewController:
                           [[PartyScene alloc]init]];
    
    _askingNavController = [[RDNavigationController alloc]initWithRootViewController:
                            [[AskingScene alloc]init]];
    
    self.viewControllers = [NSArray arrayWithObjects:_partyNavController,
                            _askingNavController,
                            nil];
    
    [_partyNavController.tabBarItem setTitle:@"聚会"];
    [_partyNavController.tabBarItem setImage:
     [IconFont imageWithIcon:[IconFont icon:@"ios7Home" fromFont:ionIcons]
                    fontName:ionIcons iconColor:[UIColor whiteColor] iconSize:25]];
    
    [_askingNavController.tabBarItem setTitle:@"说说"];
    [_askingNavController.tabBarItem setImage:
     [IconFont imageWithIcon:[IconFont icon:@"socialRss" fromFont:ionIcons]
                    fontName:ionIcons iconColor:[UIColor whiteColor] iconSize:25]];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
