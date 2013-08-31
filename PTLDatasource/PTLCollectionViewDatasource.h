//
//  PTLCollectionViewDatasource.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasource.h"

typedef void(^PTLCollectionViewCellConfigBlock)(UICollectionView *collectionView, UICollectionViewCell *cell, id item, NSIndexPath *indexPath);
typedef void(^PTLCollectionViewSupplementaryViewConfigBlock)(UICollectionView *collectionView, UICollectionReusableView *view, NSIndexPath *indexPath, NSString *elementKind);

#pragma mark - Protocol

@protocol PTLCollectionViewDatasource <PTLDatasource, UICollectionViewDataSource>

- (NSString *)collectionViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSString *)collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind;
- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlockForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind;

@end
