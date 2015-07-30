//
//  AvatarScene.m
//  iosapp
//
//  Created by Simpson Du on 26/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "AvatarScene.h"
#import "IconFont.h"
#import "UIView+FLKAutoLayout.h"
#import "UIViewController+MBHud.h"
#import <TuSDK/TuSDK.h>
#import "SDiPhoneVersion.h"
#import "QiniuUploader+Url.h"
#import "URLManager.h"
#import "AvatarSceneModel.h"
#import "NSDate+EasyExtend.h"
#import "Moment.h"

@interface AvatarScene()
{
    TuSDKCPAvatarComponent *_avatarComponent;
    QiniuUploader* _uploader;
}

@property (nonatomic, strong)UIImageView* avatarImage;
@property (nonatomic, strong)UILabel* avatarLabel;
@property (nonatomic, strong)UIButton* cameraButton;
@property (nonatomic, strong)AvatarSceneModel* sceneModel;

@end

@implementation AvatarScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addControls];
    [self loadAutoLayout];
    [self initSceneModel];
}

- (void)initView {
    self.view.backgroundColor = HEX_RGB(0xff6060);
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)addControls {
    self.avatarImage = [[UIImageView alloc] init];
    self.avatarImage.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarImage.backgroundColor = HEX_RGB(0xff7777);
    [self.view addSubview:self.avatarImage];
    
    self.avatarLabel = [[UILabel alloc] init];
    self.avatarLabel.textColor = [UIColor whiteColor];
    self.avatarLabel.text = NSLocalizedString(@"label.avatar", nil);
    [self.avatarImage addSubview:self.avatarLabel];
    
    self.cameraButton = [[UIButton alloc] init];
    self.cameraButton = [IconFont buttonWithIcon:@"\uf164" fontName:@"ionIcons" size:44 color:HEX_RGB(0xffde00)];
    self.cameraButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        _avatarComponent = [TuSDK avatarCommponentWithController:self
                                                   callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller) {
                                                       self.avatarLabel.hidden = YES;
                                                       self.avatarImage.image = result.loadResultImage;
                                                       _avatarComponent = nil;
                                                   }];
        _avatarComponent.options.editTurnAndCutOptions.saveToAlbum = NO;
        _avatarComponent.autoDismissWhenCompelted = YES;
        [_avatarComponent showComponent];
        return [RACSignal empty];
    }];
    [self.view addSubview:self.cameraButton];
    
    [self loadHud:self.view];
}

- (void)loadAutoLayout {
    NSString* size = [NSString stringWithFormat:@"%f", [[UIScreen mainScreen] bounds].size.width];
    if ([SDiPhoneVersion deviceSize] == iPhone35inch) {
        [self.avatarImage alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.avatarImage.superview];
    } else {
        [self.avatarImage alignCenterWithView:self.avatarImage.superview];
    }
    [self.avatarImage constrainWidth:size height:size];
    [self.avatarLabel alignCenterWithView:self.avatarLabel.superview];
    [self.cameraButton alignCenterXWithView:self.cameraButton.superview predicate:@"0"];
    NSArray* layouts = @[ self.avatarImage, self.cameraButton ];
    [UIView spaceOutViewsVertically:layouts predicate:@"20"];
}

- (void)initSceneModel {
    self.sceneModel = [AvatarSceneModel SceneModel];
    self.sceneModel.userId = self.params[@"userId"];
    self.sceneModel.chatId = self.params[@"chatId"];
    
    [self.sceneModel.request onRequest:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:@YES];
        [self hideHud];
    } error:^(NSError *error) {
        [self hideHudFailed:error.localizedDescription];
    }];
}

- (void)doneButtonPressed {
    [self showHudIndeterminate:NSLocalizedString(@"info.uploading", nil)];
    if (!_uploader) {
        _uploader = [[QiniuUploader alloc] init];
        @weakify(self)
        [_uploader setUploadOneFileSucceeded:^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key){
            @strongify(self)
            NSString* imageUrl = [QiniuUploader getRemoteUrl:key];
            NSString* text = NSLocalizedString(@"label.myFirstMoment", nil);
            CGFloat ratio = self.avatarImage.image.size.height / self.avatarImage.image.size.width;
            Moment* moment = [[Moment alloc] init:self.sceneModel.userId imageUrl:imageUrl text:text ratio:ratio];
            [self.sceneModel.momentRequest send:moment];
            
            NSString* screenName = [NSLocalizedString(@"label.user", nil) stringByAppendingFormat:@"%@", self.sceneModel.userId];
            [self.sceneModel.request send:self.sceneModel.userId chatId:self.sceneModel.chatId screenName:screenName avatarUrl:imageUrl];
        }];
        [_uploader setUploadOneFileFailed:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error){
            @strongify(self)
            [self hideHudFailed:[error valueForKey:@"localizedDescription"]];
        }];
    }
    QiniuFile *file = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(self.avatarImage.image, 1.0f)];
    file.key = [self.sceneModel.userId stringByAppendingFormat:@"/%@", [[NSDate date] stringWithDateFormat:@"yyyyMMddHHmmss"]];
    [_uploader addFile:file];
    [_uploader startUpload];
}

@end
