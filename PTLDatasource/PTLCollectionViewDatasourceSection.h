//
//  PTLCollectionViewDatasourceSection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Brian Partridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasourceSection.h"

typedef void(^PTLCollectionViewCellConfigBlock)(UICollectionView *collectionView, UICollectionViewCell *cell, id item, NSIndexPath *indexPath);
typedef void(^PTLCollectionViewSupplementaryViewConfigBlock)(UICollectionView *collectionView, UICollectionReusableView *view, NSIndexPath *indexPath);

@protocol PTLCollectionViewDatasourceSection <PTLDatasourceSection>

- (NSString *)collectionViewCellIdentifier;
- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlock;
- (NSString *)collectionViewSupplementaryViewIdentifier;
- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlock;

@end
