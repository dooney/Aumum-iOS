//
//  NewMomentScene.m
//  iosapp
//
//  Created by Simpson Du on 31/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "NewMomentScene.h"
#import "UIView+FLKAutoLayout.h"
#import "UIViewController+MBHud.h"
#import "NewMomentSceneModel.h"
#import "QiniuUploader+Url.h"
#import "KeyChainUtil.h"
#import "Moment.h"
#import "TagInfo.h"

@interface NewMomentScene()
{
    QiniuUploader* _uploader;
}

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) UIImage* preview;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) NewMomentSceneModel* sceneModel;
@property (nonatomic, strong) NSMutableArray* tagList;

@end

@implementation NewMomentScene

- (id)initWithImage:(UIImage*)image
            preview:(UIImage*)preview
            tagList:(NSMutableArray*)tagList {
    self = [super init];
    if (self) {
        self.image = image;
        self.preview = preview;
        self.tagList = tagList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addControls];
    [self loadAutoLayout];
    [self initSceneModel];
}

- (void)initView {
    [self.navigationController.navigationBar setBarTintColor:HEX_RGB(0xff6060)];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    UIBarButtonItem* sendButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"label.send", nil) style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonPressed)];
    self.navigationItem.rightBarButtonItem = sendButton;
}

- (void)addControls {
    self.imageView = [[UIImageView alloc] initWithImage:self.preview];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.font = [UIFont systemFontOfSize:16];
    [self.textView becomeFirstResponder];
    [self.view addSubview:self.textView];
    
    [self loadHud:self.view];
}

- (void)loadAutoLayout {
    [self.imageView alignTop:@"10" leading:@"10" toView:self.imageView.superview];
    [self.imageView constrainWidth:@"100" height:@"100"];
    
    [self.textView alignTrailingEdgeWithView:self.textView.superview predicate:@"-10"];
    
    NSArray* layouts = @[ self.imageView, self.textView ];
    [UIView alignTopEdgesOfViews:layouts];
    [UIView equalHeightForViews:layouts];
    [UIView spaceOutViewsHorizontally:layouts predicate:@"10"];
}

- (void)initSceneModel {
    self.sceneModel = [NewMomentSceneModel SceneModel];
    self.sceneModel.userId = [KeyChainUtil getCurrentUserId];
    RAC(self.sceneModel, text) = self.textView.rac_textSignal;
    
    NSMutableArray* tagList = [NSMutableArray array];
    for (NSString* tagJSONString in self.tagList) {
        TagInfo* tag = [[TagInfo alloc] initWithString:tagJSONString error:nil];
        [tagList addObject:tag.text];
    }
    [self.sceneModel.request onRequest:^{
        if (self.tagList.count > 0) {
            [self.sceneModel.tagListRequest getList:tagList];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } error:^(NSError *error) {
        [self hideHudFailed:error.localizedDescription];
    }];
    [self.sceneModel.tagListRequest onRequest:^{
        for (NSString* tagText in tagList) {
            Tag* tag = nil;
            for (Tag* item in self.sceneModel.tagListRequest.list.results) {
                if ([tagText isEqualToString:item.text]) {
                    tag = item;
                    break;
                }
            }
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            if (tag) {
                [dict setValue:@"PUT" forKey:@"method"];
                [dict setValue:[NSString stringWithFormat:@"/1/classes/Tags/%@", tag.objectId] forKey:@"path"];
                [dict setValue:@{ @"moments" : @{ @"__op" : @"AddUnique", @"objects" : @[ self.sceneModel.request.objectId ] },
                                  @"hot" : @{ @"__op" : @"Increment", @"amount" : @1 } } forKey:@"body"];
            } else {
                [dict setValue:@"POST" forKey:@"method"];
                [dict setValue:@"/1/classes/Tags" forKey:@"path"];
                [dict setValue:@{ @"text" : tagText, @"moments" : @[ self.sceneModel.request.objectId ] } forKey:@"body"];
            }
            [self.sceneModel.batchRequest.requests addObject:dict];
        }
        [self.sceneModel.batchRequest send];
    } error:^(NSError *error) {
    }];
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendButtonPressed {
    [self.textView resignFirstResponder];
    [self showHudIndeterminate:NSLocalizedString(@"info.sending", nil)];
    if (!_uploader) {
        _uploader = [[QiniuUploader alloc] init];
        @weakify(self)
        [_uploader setUploadOneFileSucceeded:^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key){
            @strongify(self)
            NSString* imageUrl = [QiniuUploader getRemoteUrl:key];
            CGFloat ratio = self.image.size.height / self.image.size.width;
            Moment* moment = [[Moment alloc] init:self.sceneModel.userId
                                         imageUrl:imageUrl
                                             text:self.sceneModel.text
                                            ratio:ratio
                                             tags:self.tagList];
            [self.sceneModel.request send:moment];
        }];
        [_uploader setUploadOneFileFailed:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error){
            @strongify(self)
            [self hideHudFailed:[error valueForKey:@"localizedDescription"]];
        }];
    }
    QiniuFile *file = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(self.image, 1.0f)];
    file.key = [self.sceneModel.userId stringByAppendingFormat:@"/%@", [[NSDate date] stringWithDateFormat:@"yyyyMMddHHmmss"]];
    [_uploader addFile:file];
    [_uploader startUpload];
}

@end
