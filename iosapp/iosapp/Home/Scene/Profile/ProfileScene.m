//
//  ProfileScene.m
//  iosapp
//
//  Created by Simpson Du on 9/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ProfileScene.h"
#import "UserSceneModel.h"
#import "NSDate+Category.h"
#import "PhotoCell.h"
#import "URLManager.h"
#import "CSStickyHeaderFlowLayout.h"
#import "UserHeader.h"
#import "UserSectionHeader.h"

@interface ProfileScene()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UserSceneModel* sceneModel;
@property (nonatomic, strong)UICollectionView* collectionView;

@end

@implementation ProfileScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addControls];
    [self initSceneModel];
}

- (void)addControls {
    UIButton* settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setFrame:CGRectMake(0, 0, 30, 30)];
    [settingsButton addTarget:self action:@selector(settingsButtonPressed)forControlEvents:UIControlEventTouchUpInside];
    [settingsButton setImage:[IconFont imageWithIcon:[IconFont icon:@"ios7Gear" fromFont:ionIcons] fontName:ionIcons iconColor:[UIColor whiteColor] iconSize:30] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    CSStickyHeaderFlowLayout* flowLayout = [[CSStickyHeaderFlowLayout alloc] init];
    flowLayout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 200);
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
    
    self.sceneModel.profile = [Profile get];
    UserDetails* userDetails = [[UserDetails alloc] init];
    userDetails.screenName = self.sceneModel.profile.screenName;
    userDetails.avatarUrl = self.sceneModel.profile.avatarUrl;
    userDetails.country = self.sceneModel.profile.country;
    userDetails.city = self.sceneModel.profile.city;
    self.sceneModel.request.userDetails = userDetails;
    [self.sceneModel.momentListRequest getListByUserId:self.sceneModel.profile.objectId before:[NSDate utcNow]];
    [self.sceneModel.momentListRequest onRequest:^{
        [self.collectionView reloadData];
    } error:^(NSError *error) {
        [self showError:error];
    }];
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
        [cell reloadData:self.sceneModel.request.userDetails];
        return cell;
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UserHeader* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                              withReuseIdentifier:@"UserHeader"
                                                                     forIndexPath:indexPath];
        [cell reloadData:self.sceneModel.request.userDetails];
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

- (void)settingsButtonPressed {
}

@end
