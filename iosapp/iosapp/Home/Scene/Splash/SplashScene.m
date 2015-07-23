//
//  SplashScene.m
//  iosapp
//
//  Created by Simpson Du on 7/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "SplashScene.h"
#import "UIView+FLKAutoLayout.h"
#import "URLManager.h"

@interface SplashScene()

@property (nonatomic, strong)UIButton* signInButton;

@end

@implementation SplashScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addControls];
    [self loadAutoLayout];
}

- (void)initView {
    self.view.backgroundColor = HEX_RGB(0xff6060);
}

- (void)addControls {
    self.signInButton = [[UIButton alloc] init];
    [self.signInButton setTitle:NSLocalizedString(@"label.signIn", @"Sign In") forState:UIControlStateNormal];
    self.signInButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [URLManager pushURLString:@"iosapp://signIn" animated:YES];
        return [RACSignal empty];
    }];
    [self.view addSubview:self.signInButton];
}

- (void)loadAutoLayout{
    [self.signInButton alignCenterWithView:self.signInButton.superview];
}

@end
