//
//  AddTagScene.m
//  iosapp
//
//  Created by Simpson Du on 10/09/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AddTagScene.h"
#import "UITextField+Padding.h"
#import "UITextField+History.h"
#import "UIView+FLKAutoLayout.h"

@interface AddTagScene()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField* textField;

@end

@implementation AddTagScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addControls];
    [self loadAutoLayout];
}

- (void)initView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
    self.view.backgroundColor = HEX_RGB(0x333333);
}

- (void)addControls {
    self.textField = [[UITextField alloc] init];
    self.textField.delegate = self;
    self.textField.identify = @"TEXT_ID";
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.layer.cornerRadius = 5.0f;
    [self.textField becomeFirstResponder];
    [self.view addSubview:self.textField];
}

- (void)loadAutoLayout {
    [self.textField constrainHeight:@"40"];
    [self.textField alignTop:@"84" leading:@"20" bottom:nil trailing:@"-20" toView:self.textField.superview];
}

- (void)saveButtonPressed {
    [self.textField synchronize];
    [self.delegate getTag:self.textField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    if (textField == self.textField) {
        [textField showHistory];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField; {
    if (textField == self.textField) {
        [textField hideHistroy];
    }
}

@end
