//
//  ProfileScene.m
//  iosapp
//
//  Created by Simpson Du on 9/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ProfileScene.h"
#import "UIColor+EasyExtend.h"
#import "Constants.h"
#import "UIView+FLKAutoLayout.h"
#import "KeyChainUtil.h"
#import "URLManager.h"

@interface ProfileScene()

@property (nonatomic, strong)UIButton* logoutButton;

@end

@implementation ProfileScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoutButton = [[UIButton alloc] initNavigationButtonWithTitle:@"Log Out" color:HEX_RGB(AM_YELLOW)];
    self.logoutButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [KeyChainUtil resetToken];
        [KeyChainUtil resetCurrentUserId];
        [URLManager presentURLString:@"iosapp://splash" animated:YES];
        return [RACSignal empty];
    }];
    [self.view addSubview:self.logoutButton];
    
    [self loadAutoLayout];
}

- (void)loadAutoLayout {
    [self.logoutButton alignToView:self.logoutButton.superview];
}

@end
