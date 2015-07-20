//
//  UserScene.m
//  iosapp
//
//  Created by Administrator on 11/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserScene.h"
#import "UserSceneModel.h"
#import "UIView+FLKAutoLayout.h"
#import "ChatScene.h"
#import "URLManager.h"

@interface UserScene()

@property (nonatomic, strong)UserSceneModel* sceneModel;

@property (nonatomic, strong)UIButton* chatButton;
@property (nonatomic, strong)UIButton* addContactButton;

@end

@implementation UserScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSceneModel];
}

- (void)initSceneModel {
    self.sceneModel = [UserSceneModel SceneModel];
    
    self.sceneModel.profile = [Profile get];
    NSString* userId = self.params[@"userId"];
    [self.sceneModel.request send:userId];
    
    [self.sceneModel.request onRequest:^{
        if ([self.sceneModel.profile.contacts containsObject:userId]) {
            self.chatButton = [[UIButton alloc] init];
            [self.chatButton setTitle:NSLocalizedString(@"label.chat", @"Chat") forState:UIControlStateNormal];
            self.chatButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                ChatScene* chatScene = [[ChatScene alloc] initWithUserId:self.sceneModel.request.userDetails.objectId];
                [self.navigationController pushViewController:chatScene animated:YES];
                return [RACSignal empty];
            }];
            [self.view addSubview:self.chatButton];
            [self.chatButton alignCenterWithView:self.chatButton.superview];
        } else if (![self.sceneModel.profile.objectId isEqualToString:userId]) {
            self.addContactButton = [[UIButton alloc] init];
            [self.addContactButton setTitle:NSLocalizedString(@"label.addContact", @"AddContact") forState:UIControlStateNormal];
            [self.view addSubview:self.addContactButton];
            [self.addContactButton alignCenterWithView:self.addContactButton.superview];
        }
    } error:^(NSError *error) {
        [self showError:error];
    }];
}

@end
