//
//  PTLDatasource+CollectionView.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource.h"

typedef void(^PTLCollectionViewCellConfigBlock)(UICollectionView *collectionView, UICollectionViewCell *cell, id item, NSIndexPath *indexPath);
typedef void(^PTLCollectionViewSupplementaryViewConfigBlock)(UICollectionView *collectionView, UICollectionReusableView *view, NSIndexPath *indexPath);

#pragma mark - Protocol

@protocol PTLCollectionViewDatasource <PTLDatasource>

- (NSString *)collectionViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSString *)collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlockForIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - Implementation

@interface PTLDatasource (CollectionView) <PTLCollectionViewDatasource>

@property (nonatomic, copy) NSString *collectionViewCellIdentifier;
@property (nonatomic, copy) PTLCollectionViewCellConfigBlock collectionViewCellConfigBlock;
@property (nonatomic, copy) NSString *collectionViewSupplementaryViewIdentifier;
@property (nonatomic, copy) PTLCollectionViewSupplementaryViewConfigBlock collectionViewSupplementaryViewConfigBlock;

- (void)setCollectionViewCellIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)setCollectionViewCellConfigBlock:(PTLCollectionViewCellConfigBlock)block forIndexPath:(NSIndexPath *)indexPath;
- (void)setCollectionViewSupplementaryViewIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)setCollectionViewSupplementaryViewConfigBlock:(PTLCollectionViewSupplementaryViewConfigBlock)block forIndexPath:(NSIndexPath *)indexPath;

@end
