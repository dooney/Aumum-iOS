//
//  AddContactScene.m
//  iosapp
//
//  Created by Simpson Du on 17/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AddContactScene.h"
#import "UIView+FLKAutoLayout.h"
#import "UIViewController+MBHud.h"
#import "URLManager.h"
#import "EaseMob.h"

@interface AddContactScene()
{
    NSString* _userId;
    NSString* _screenName;
}

@property (nonatomic, strong) UITextView* text;

@end

@implementation AddContactScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userId = self.params[@"userId"];
    _screenName = self.params[@"name"];
    
    [self initView];
    [self addControls];
    [self loadAutoLayout];
    [self initSceneModel];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem* sendButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"label.send", nil) style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonPressed)];
    self.navigationItem.rightBarButtonItem = sendButton;
}

- (void)addControls {
    self.text = [[UITextView alloc] init];
    self.text.font = [UIFont systemFontOfSize:16];
    self.text.text = [NSString stringWithFormat:NSLocalizedString(@"label.contactRequest", nil), _screenName];
    [self.view addSubview:self.text];
    
    [self loadHud:self.view];
}

- (void)loadAutoLayout {
    [self.text alignTop:@"10" leading:@"10" bottom:@"-10" trailing:@"-10" toView:self.text.superview];
}

- (void)initSceneModel {
}

- (void)sendButtonPressed {
    [self showHudIndeterminate:nil];
    EMError *error;
    [[EaseMob sharedInstance].chatManager addBuddy:[_userId lowercaseString] message:self.text.text error:&error];
    if (error) {
        [self hideHudFailed:error.description];
    } else {
        [self showSuccess:NSLocalizedString(@"info.sentSuccessfully", nil) message:NSLocalizedString(@"label.waitForApproval", nil)];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
