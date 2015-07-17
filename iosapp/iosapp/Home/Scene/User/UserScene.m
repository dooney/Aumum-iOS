//
//  UserScene.m
//  iosapp
//
//  Created by Administrator on 11/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserScene.h"
#import "UIView+FLKAutoLayout.h"
#import "ChatScene.h"
#import "URLManager.h"

@interface UserScene()

@property (nonatomic, strong)NSString* userId;
@property (nonatomic, strong)UIButton* chatButton;

@end

@implementation UserScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userId = self.params[@"userId"];
    
    self.chatButton = [[UIButton alloc] init];
    self.chatButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        ChatScene* chatScene = [[ChatScene alloc] initWithUserId:self.userId];
        [self.navigationController pushViewController:chatScene animated:YES];
        return [RACSignal empty];
    }];
    [self.view addSubview:self.chatButton];
    
    [self loadAutoLayout];
}

- (void)loadAutoLayout {
    [self.chatButton alignToView:self.chatButton.superview];
}

@end
