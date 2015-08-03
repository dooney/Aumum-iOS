//
//  MomentDetailsScene.m
//  iosapp
//
//  Created by Simpson Du on 2/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentDetailsScene.h"

@interface MomentDetailsScene()

@property (nonatomic, strong)NSString* momentId;

@end

@implementation MomentDetailsScene

- (id)initWithMomentId:(NSString*)momentId {
    self = [super init];
    if (self) {
        self.momentId = momentId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:HEX_RGB(0xff6060)];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
