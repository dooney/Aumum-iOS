//
// Created by Simpson Du on 1/07/15.
// Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentScene.h"
#import "MomentListSceneModel.h"
#import "SceneTableView.h"
#import "UIView+FLKAutoLayout.h"
#import "MomentCell.h"
#import "Moment.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+EndReflash.h"
#import "UIAlertController+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import <TuSDK/TuSDK.h>
#import <TSMessage.h>
#import "RDNavigationController.h"
#import "NewMomentScene.h"
#import "MomentDetailsScene.h"
#import "NSArray+EasyExtend.h"

@interface MomentScene()<UITableViewDelegate, UITableViewDataSource, TuSDKPFCameraDelegate>
{
    TuSDKCPAlbumComponent *_albumComponent;
    TuSDKCPPhotoEditMultipleComponent *_photoEditMultipleComponent;
}

@property (strong, nonatomic) MomentListSceneModel* sceneModel;
@property (strong, nonatomic) SceneTableView* tableView;
@property (strong, nonatomic) UIBarButtonItem* cameraButton;

@end

@implementation MomentScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addControls];
    [self initSceneModel];
    [self.tableView triggerPullToRefresh];
}

- (void)initView {
    self.cameraButton = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                         target:self
                         action:@selector(cameraButtonPressed)];
    self.navigationItem.rightBarButtonItem = self.cameraButton;
}

- (void)addControls {
    self.tableView = [[SceneTableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.fd_debugLogEnabled = YES;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    [self.tableView registerClass:[MomentCell class] forCellReuseIdentifier:@"MomentCell"];
    @weakify(self);
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        Moment* moment = [self.sceneModel.dataSet firstObject];
        [self.sceneModel.pullRequest send:nil after:moment.createdAt];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        Moment* moment = [self.sceneModel.dataSet lastObject];
        [self.sceneModel.loadRequest send:moment.createdAt after:nil];
    }];
}

- (void)onRequest:(MomentListRequest*)request
      dataHandler:(void (^)(NSMutableArray* data))dataHandler
     emptyHandler:(void (^)())emptyHandler{
    if (request.list &&
        request.list.results.count > 0) {
        if (!self.sceneModel.dataSet) {
            self.sceneModel.dataSet = [NSMutableArray array];
        }
        dataHandler(request.list.results);
        NSMutableArray* userIdList = [NSMutableArray array];
        for (Moment* moment in request.list.results) {
            if (![userIdList containsObject:moment.userId]) {
                [userIdList addObject:moment.userId];
            }
        }
        [self.sceneModel.userListRequest send:userIdList];
    } else {
        emptyHandler();
    }
}

- (void)initSceneModel {
    self.sceneModel = [MomentListSceneModel SceneModel];
    
    [self.sceneModel.pullRequest onRequest:^() {
        [self onRequest:self.sceneModel.pullRequest dataHandler:^(NSMutableArray* data){
            [self.sceneModel.dataSet pushHeadN:data];
        } emptyHandler:^{
            [self.tableView endAllRefreshingWithEnd:NO];
        }];
    } error:^(NSError* error) {
        [self showError:error];
    }];
    
    [self.sceneModel.loadRequest onRequest:^() {
        [self onRequest:self.sceneModel.loadRequest dataHandler:^(NSMutableArray* data){
            [self.sceneModel.dataSet addObjectsFromArray:data];
        } emptyHandler:^{
            [self.tableView endAllRefreshingWithEnd:self.sceneModel.loadRequest.isEnd.boolValue];
        }];
    } error:^(NSError* error) {
        [self showError:error];
    }];
    
    [self.sceneModel.userListRequest onRequest:^() {
        for (Moment* moment in self.sceneModel.dataSet) {
            for (User* user in self.sceneModel.userListRequest.list.results) {
                if ([moment.userId isEqualToString:user.objectId]) {
                    moment.user = user;
                }
            }
        }
        [self.tableView reloadData];
        [self.tableView endAllRefreshingWithEnd:self.sceneModel.loadRequest.isEnd.boolValue];
    } error:^(NSError* error) {
        [self showError:error];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.dataSet.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MomentCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.viewController = self;
    Moment* moment = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    [cell reloadData:moment];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"MomentCell" cacheByIndexPath:indexPath configuration:^(MomentCell *cell) {
        Moment* moment = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
        [cell reloadData:moment];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Moment* moment = [self.sceneModel.dataSet objectAtIndex:indexPath.row];
    MomentDetailsScene* scene = [[MomentDetailsScene alloc] initWithMomentId:moment.objectId promptInput:NO];
    RDNavigationController* navigationController = [[RDNavigationController alloc] initWithRootViewController:scene];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:navigationController animated:YES completion:nil];
    });
}

- (void)cameraButtonPressed {
    if ([UIAlertController class]) {
        [UIAlertController showActionSheetInViewController:self
                                                 withTitle:NSLocalizedString(@"label.newMoment", nil)
                                                   message:nil
                                         cancelButtonTitle:NSLocalizedString(@"label.cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@[ NSLocalizedString(@"label.takePhoto", nil), NSLocalizedString(@"label.chooseFromAlbum", nil) ]
                        popoverPresentationControllerBlock:nil
                                                  tapBlock:^(UIAlertController* controller, UIAlertAction* action, NSInteger buttonIndex) {
                                                      [self handleCameraButtonOptions:buttonIndex];
                                                  }];
    } else {
        [UIActionSheet showFromBarButtonItem:self.cameraButton
                                    animated:YES
                                   withTitle:NSLocalizedString(@"label.newMoment", nil)
                           cancelButtonTitle:NSLocalizedString(@"label.cancel", nil)
                      destructiveButtonTitle:nil
                           otherButtonTitles:@[ NSLocalizedString(@"label.takePhoto", nil), NSLocalizedString(@"label.chooseFromAlbum", nil) ]
                                    tapBlock:^(UIActionSheet* actionSheet, NSInteger buttonIndex) {
                                        [self handleCameraButtonOptions:buttonIndex];
                                    }];
    }
}

- (void)handleCameraButtonOptions:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        TuSDKPFCameraOptions *opt = [TuSDKPFCameraOptions build];
        opt.saveToAlbum = YES;
        TuSDKPFCameraViewController *controller = opt.viewController;
        controller.delegate = self;
        [self presentModalNavigationController:controller animated:YES];
    } else if (buttonIndex == 1) {
        _albumComponent =
        [TuSDK albumCommponentWithController:self
                               callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
         {
             [self showEditComponent:controller image:result.loadResultImage];
         }];
        [_albumComponent showComponent];
    }
}

- (void)onTuSDKPFCamera:(TuSDKPFCameraViewController *)controller captureResult:(TuSDKResult *)result {
    UIImage* image = [result.imageAsset fullResolutionImage];
    [self showEditComponent:controller image:image];
}

- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error {
    [TSMessage showNotificationWithTitle:nil
                                subtitle:error.localizedDescription
                                    type:TSMessageNotificationTypeError];
}

- (void)showEditComponent:(UIViewController*)controller
                    image:(UIImage*)image {
    _photoEditMultipleComponent =
    [TuSDK photoEditMultipleWithController:controller
                             callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         _albumComponent = nil;
         NewMomentScene* scene = [[NewMomentScene alloc] initWithImage:result.loadResultImage];
         [controller pushViewController:scene animated:YES];
     }];
    _photoEditMultipleComponent.options.editMultipleOptions.saveToAlbum = NO;
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionAdjust];
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionSharpness];
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionVignette];
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionAperture];
    _photoEditMultipleComponent.inputImage = image;
    [_photoEditMultipleComponent showComponent];
}

@end