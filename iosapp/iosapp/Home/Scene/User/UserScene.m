//
//  UserScene.m
//  iosapp
//
//  Created by Administrator on 11/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "UserScene.h"
#import "UserSceneModel.h"
#import "Profile.h"
#import "UIView+FLKAutoLayout.h"
#import "NSDate+Category.h"
#import "PhotoCell.h"
#import "ChatScene.h"
#import "URLManager.h"
#import "CSStickyHeaderFlowLayout.h"
#import "UserHeader.h"
#import "UserSectionHeader.h"
#import "IconFont.h"

@interface UserScene()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSString* _userId;
    Profile* _profile;
}

@property (nonatomic, strong)UserSceneModel* sceneModel;
@property (nonatomic, strong)UICollectionView* collectionView;

@end

@implementation UserScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addControls];
    [self initSceneModel];
}

- (void)addControls {
    CSStickyHeaderFlowLayout* flowLayout = [[CSStickyHeaderFlowLayout alloc] init];
    flowLayout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 240);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    [self.collectionView registerClass:[UserSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UserSectionHeader"];
    [self.collectionView registerClass:[UserHeader class] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:@"UserHeader"];
}

- (void)initSceneModel {
    self.sceneModel = [UserSceneModel SceneModel];
    
    _profile = [Profile get];
    _userId = self.params[@"userId"];
    [self.sceneModel.request send:_userId];
    
    [self.sceneModel.request onRequest:^{
        [self.sceneModel.momentListRequest getListByUserId:_userId before:[NSDate utcNow]];
    } error:^(NSError *error) {
        [self showError:error];
    }];
    
    [self.sceneModel.momentListRequest onRequest:^{
        [self.collectionView reloadData];
        [self showActionButton];
    } error:^(NSError *error) {
        [self showError:error];
    }];
}

- (void)showActionButton {
    if (![_profile.objectId isEqualToString:_userId]) {
        UIButton* actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionButton setFrame:CGRectMake(0, 0, 30, 30)];
        [actionButton addTarget:self action:@selector(actionButtonPressed)forControlEvents:UIControlEventTouchUpInside];
        NSString* icon;
        if ([_profile.contacts containsObject:_userId]) {
            icon = @"ios7Chatbubble";
        } else {
            icon = @"ios7Personadd";
        }
        [actionButton setImage:[IconFont imageWithIcon:[IconFont icon:icon fromFont:ionIcons] fontName:ionIcons iconColor:[UIColor whiteColor] iconSize:30] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:actionButton];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sceneModel.momentListRequest.list.results.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = (PhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    Moment* moment = [self.sceneModel.momentListRequest.list.results objectAtIndex:indexPath.item];
    [cell reloadData:moment.imageUrl];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UserSectionHeader* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                     withReuseIdentifier:@"UserSectionHeader"
                                                                            forIndexPath:indexPath];
        [cell reloadUser:self.sceneModel.request.userDetails];
        return cell;
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UserHeader* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                              withReuseIdentifier:@"UserHeader"
                                                                     forIndexPath:indexPath];
        [cell reloadUser:self.sceneModel.request.userDetails];
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Moment* moment = [self.sceneModel.momentListRequest.list.results objectAtIndex:indexPath.item];
    NSString* url = [NSString stringWithFormat:@"iosapp://moment?momentId=%@", moment.objectId];
    [URLManager pushURLString:url animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 54);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat collectionWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat itemWidth = collectionWidth / 3 - 1;
    return CGSizeMake(itemWidth, itemWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (void)actionButtonPressed {
    if ([_profile.contacts containsObject:_userId]) {
        ChatScene* chatScene = [[ChatScene alloc] initWithUserId:_userId];
        chatScene.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatScene animated:YES];
    } else {
        NSString* url = [NSString stringWithFormat:@"iosapp://addContact?userId=%@&name=%@", _userId, _profile.screenName];
        [URLManager pushURLString:url animated:YES];
    }
}

@end
