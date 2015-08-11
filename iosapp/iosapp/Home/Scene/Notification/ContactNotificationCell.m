//
//  ContactNotificationCell.m
//  iosapp
//
//  Created by Simpson Du on 9/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ContactNotificationCell.h"
#import "UIView+FLKAutoLayout.h"
#import "UIColor+EasyExtend.h"
#import "ChatSendHelper.h"

@interface ContactNotificationCell()

@property (nonatomic, strong) UIButton* acceptButton;

@end

@implementation ContactNotificationCell

- (void)initRightLayout:(UIView *)rightLayout {
    [super initRightLayout:rightLayout];
    
    self.acceptButton = [[UIButton alloc] init];
    self.acceptButton.layer.cornerRadius = 5;
    self.acceptButton.backgroundColor = HEX_RGB(0xff6060);
    self.acceptButton.contentEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    self.acceptButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.acceptButton setTitle:NSLocalizedString(@"label.accept", nil) forState:UIControlStateNormal];
    [self.acceptButton addTarget:self action:@selector(acceptButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [rightLayout addSubview:self.acceptButton];
    
    [self.acceptButton alignCenterWithView:self.acceptButton.superview];
}

- (void)acceptButtonPressed {
    [ChatSendHelper sendTextMessageWithString:NSLocalizedString(@"label.requestAccepted", nil)
                                   toUsername:[self.notification.userId lowercaseString]
                                  messageType:eMessageTypeChat
                            requireEncryption:NO
                                          ext:nil];
    [self.delegate didPressAcceptButton:self];
}

@end
