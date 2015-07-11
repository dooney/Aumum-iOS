//
//  UserScene.m
//  iosapp
//
//  Created by Administrator on 11/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserScene.h"
#import "UIColor+EasyExtend.h"
#import "Constants.h"
#import "UIView+FLKAutoLayout.h"

@interface UserScene()

@property (nonatomic, strong)UIButton* chatButton;

@end

@implementation UserScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatButton = [[UIButton alloc] initNavigationButtonWithTitle:@"Chat" color:HEX_RGB(AM_YELLOW)];
    self.chatButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    [self.view addSubview:self.chatButton];
    
    [self loadAutoLayout];
}

- (void)loadAutoLayout {
    [self.chatButton alignToView:self.chatButton.superview];
}

@end
