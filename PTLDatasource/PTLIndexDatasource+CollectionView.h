//
//  PTLIndexDatasource+CollectionView.h
//  PTLDatasource
//
//  Created by Brian Partridge on 8/26/13.
//
//

#import "PTLIndexDatasource.h"
#import "PTLCollectionViewDatasource.h"

@interface PTLIndexDatasource (CollectionView) <PTLCollectionViewDatasource>

@property (nonatomic, copy) NSString *collectionViewCellIdentifier;
@property (nonatomic, copy) PTLCollectionViewCellConfigBlock collectionViewCellConfigBlock;

// Flow Layout

@property (nonatomic, copy) NSString *collectionViewHeaderIdentifier;
@property (nonatomic, copy) PTLCollectionViewSupplementaryViewConfigBlock collectionViewHeaderConfigBlock;

@property (nonatomic, copy) NSString *collectionViewFooterIdentifier;
@property (nonatomic, copy) PTLCollectionViewSupplementaryViewConfigBlock collectionViewFooterConfigBlock;

// Custom Layout

- (void)setCollectionViewSupplementaryViewIdentifier:(NSString *)identifier forElementKind:(NSString *)elementKind;
- (void)setCollectionViewSupplementaryViewConfigBlock:(PTLCollectionViewSupplementaryViewConfigBlock)configBlock forElementKind:(NSString *)elementKind;

@end
