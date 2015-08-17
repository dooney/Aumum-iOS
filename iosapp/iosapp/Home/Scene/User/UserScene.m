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
#import "NSDate+Category.h"
#import "PhotoCell.h"
#import "ChatScene.h"
#import "URLManager.h"
#import "CSStickyHeaderFlowLayout.h"
#import "UserHeader.h"

@interface UserScene()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

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
    flowLayout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 200);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
    [self.collectionView registerClass:[UserHeader class] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:@"UserHeader"];
}

- (void)initSceneModel {
    self.sceneModel = [UserSceneModel SceneModel];
    
    self.sceneModel.profile = [Profile get];
    NSString* userId = self.params[@"userId"];
    [self.sceneModel.request send:userId];
    
    [self.sceneModel.request onRequest:^{
        [self.sceneModel.momentListRequest getListByUserId:userId before:[NSDate utcNow]];
    } error:^(NSError *error) {
        [self showError:error];
    }];
    
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
        UICollectionReusableView* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"SectionHeader"
                                                                                   forIndexPath:indexPath];
        cell.backgroundColor = HEX_RGB(0xf4f4f4);
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOffset = CGSizeZero;
        cell.layer.shadowRadius = 3;
        cell.layer.shadowOpacity = 0.3;
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
    return CGSizeMake(self.view.frame.size.width, 20);
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

@end
