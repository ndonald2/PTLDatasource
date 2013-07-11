//
//  PTLCollectionViewDatasource.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Brian Partridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasource.h"

typedef void(^PTLCollectionViewCellConfigBlock)(UICollectionView *collectionView, UICollectionViewCell *cell, id item, NSIndexPath *indexPath);
typedef void(^PTLCollectionViewSupplementaryViewConfigBlock)(UICollectionView *collectionView, UICollectionReusableView *view, NSIndexPath *indexPath);

@protocol PTLCollectionViewDatasource <PTLDatasource>

- (NSString *)collectionViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlockForIndexPath:(NSIndexPath *)indexPath;

@end
