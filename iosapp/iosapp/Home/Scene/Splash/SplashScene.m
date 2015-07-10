//
//  SplashScene.m
//  iosapp
//
//  Created by Simpson Du on 7/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "SplashScene.h"
#import "UIButton+EasyExtend.h"
#import "UIColor+EasyExtend.h"
#import "Constants.h"
#import "UIView+FLKAutoLayout.h"
#import "RDNavigationController.h"
#import "SignInScene.h"

@interface SplashScene()

@property (nonatomic, strong)UIButton* signInButton;

@end

@implementation SplashScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signInButton = [[UIButton alloc] initNavigationButtonWithTitle:@"Sign In" color:HEX_RGB(AM_YELLOW)];
    self.signInButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RDNavigationController* signInController = [[RDNavigationController alloc] initWithRootViewController:[[SignInScene alloc] init]];
        [self presentViewController:signInController animated:YES completion:nil];
        return [RACSignal empty];
    }];
    [self.view addSubview:self.signInButton];
    
    [self loadAutoLayout];
}

- (void)loadAutoLayout{
    [self.signInButton alignToView:self.signInButton.superview];
}

@end
