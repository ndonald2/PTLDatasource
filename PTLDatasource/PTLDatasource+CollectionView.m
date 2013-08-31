//
//  PTLDatasource+CollectionView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 8/30/13.
//
//

#import "PTLDatasource+CollectionView.h"
#import <objc/runtime.h>

static NSString * const kPTLCollectionViewDatasourceCellIdentifier = @"kPTLCollectionViewDatasourceCellIdentifier";
static NSString * const kPTLCollectionViewDatasourceCellConfigBlock = @"kPTLCollectionViewDatasourceCellConfigBlock";
static NSString * const kPTLCollectionViewDatasourceElementKindToReusableViewIdentifier = @"kPTLCollectionViewDatasourceElementKindToReusableViewIdentifier";
static NSString * const kPTLCollectionViewDatasourceElementKindToReusableViewConfigBlock = @"kPTLCollectionViewDatasourceElementKindToReusableViewConfigBlock";

@implementation PTLDatasource (CollectionView)

#pragma mark - Properties

- (void)setCollectionViewCellIdentifier:(NSString *)collectionViewCellIdentifier {
   objc_setAssociatedObject(self, (__bridge const void *)(kPTLCollectionViewDatasourceCellIdentifier), collectionViewCellIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)collectionViewCellIdentifier {
   return objc_getAssociatedObject(self, (__bridge const void *)(kPTLCollectionViewDatasourceCellIdentifier));
}

- (void)setCollectionViewCellConfigBlock:(PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlock {
   objc_setAssociatedObject(self, (__bridge const void *)(kPTLCollectionViewDatasourceCellConfigBlock), collectionViewCellConfigBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlock {
   return objc_getAssociatedObject(self, (__bridge const void *)(kPTLCollectionViewDatasourceCellConfigBlock));
}

#pragma mark - Flow Layout

- (void)setCollectionViewHeaderIdentifier:(NSString *)collectionViewHeaderIdentifier {
   [self setCollectionViewSupplementaryViewIdentifier:collectionViewHeaderIdentifier forElementKind:UICollectionElementKindSectionHeader];
}

- (NSString *)collectionViewHeaderIdentifier {
   return [self collectionViewSupplementaryViewIdentifierForIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] elementKind:UICollectionElementKindSectionHeader];
}

- (void)setCollectionViewHeaderConfigBlock:(PTLCollectionViewSupplementaryViewConfigBlock)collectionViewHeaderConfigBlock {
   [self setCollectionViewSupplementaryViewConfigBlock:collectionViewHeaderConfigBlock forElementKind:UICollectionElementKindSectionHeader];
}

- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewHeaderConfigBlock {
   return [self collectionViewSupplementaryViewConfigBlockForIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] elementKind:UICollectionElementKindSectionHeader];
}

- (void)setCollectionViewFooterIdentifier:(NSString *)collectionViewFooterIdentifier {
   [self setCollectionViewSupplementaryViewIdentifier:collectionViewFooterIdentifier forElementKind:UICollectionElementKindSectionFooter];
}

- (NSString *)collectionViewFooterIdentifier {
   return [self collectionViewSupplementaryViewIdentifierForIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] elementKind:UICollectionElementKindSectionFooter];
}

- (void)setCollectionViewFooterConfigBlock:(PTLCollectionViewSupplementaryViewConfigBlock)collectionViewFooterConfigBlock {
   [self setCollectionViewSupplementaryViewConfigBlock:collectionViewFooterConfigBlock forElementKind:UICollectionElementKindSectionFooter];
}

- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewFooterConfigBlock {
   return [self collectionViewSupplementaryViewConfigBlockForIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] elementKind:UICollectionElementKindSectionFooter];
}

#pragma mark - Custom Layout

- (void)setCollectionViewSupplementaryViewIdentifier:(NSString *)identifier forElementKind:(NSString *)elementKind {
   NSMapTable *table = objc_getAssociatedObject(self, (__bridge const void *)(kPTLCollectionViewDatasourceElementKindToReusableViewIdentifier));
   if (table == nil) {
      table = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsCopyIn capacity:1];
      objc_setAssociatedObject(self, (__bridge const void *)(kPTLCollectionViewDatasourceElementKindToReusableViewIdentifier), table, OBJC_ASSOCIATION_RETAIN);
   }
   [table setObject:identifier forKey:elementKind];
}

- (void)setCollectionViewSupplementaryViewConfigBlock:(PTLCollectionViewSupplementaryViewConfigBlock)configBlock forElementKind:(NSString *)elementKind {
   NSMapTable *table = objc_getAssociatedObject(self, (__bridge const void *)(kPTLCollectionViewDatasourceElementKindToReusableViewConfigBlock));
   if (table == nil) {
      table = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsCopyIn capacity:1];
      objc_setAssociatedObject(self, (__bridge const void *)(kPTLCollectionViewDatasourceElementKindToReusableViewConfigBlock), table, OBJC_ASSOCIATION_RETAIN);
   }
   [table setObject:configBlock forKey:elementKind];
}

#pragma mark - Protocol Methods

- (NSString *)collectionViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
   NSParameterAssert(indexPath.section < [self numberOfSections]);
   NSParameterAssert(indexPath.item < [self numberOfItemsInSection:indexPath.section]);
   return self.collectionViewCellIdentifier;
}

- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
   NSParameterAssert(indexPath.section < [self numberOfSections]);
   NSParameterAssert(indexPath.item < [self numberOfItemsInSection:indexPath.section]);
   return self.collectionViewCellConfigBlock;
}

- (NSString *)collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind {
   NSParameterAssert(indexPath.section < [self numberOfSections]);
   NSParameterAssert(indexPath.item < [self numberOfItemsInSection:indexPath.section]);
   NSMapTable *table = objc_getAssociatedObject(self, (__bridge const void *)(kPTLCollectionViewDatasourceElementKindToReusableViewIdentifier));
   return [table objectForKey:elementKind];
}

- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlockForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind {
   NSParameterAssert(indexPath.section < [self numberOfSections]);
   NSParameterAssert(indexPath.item < [self numberOfItemsInSection:indexPath.section]);
   NSMapTable *table = objc_getAssociatedObject(self, (__bridge const void *)(kPTLCollectionViewDatasourceElementKindToReusableViewConfigBlock));
   return [table objectForKey:elementKind];
}

#pragma mark - UICollectionViewDatasource Required Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return [self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self collectionViewCellIdentifierForIndexPath:indexPath]
                                                                          forIndexPath:indexPath];
   PTLCollectionViewCellConfigBlock block = [self collectionViewCellConfigBlockForIndexPath:indexPath];
   if (block != nil) {
      block(collectionView, cell, [self itemAtIndexPath:indexPath], indexPath);
   }
   return cell;
}

#pragma mark - UICollectionViewDatasource Optional Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   return [self numberOfSections];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
   NSString *identifier = [self collectionViewSupplementaryViewIdentifierForIndexPath:indexPath elementKind:kind];
   UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                       withReuseIdentifier:identifier
                                                                              forIndexPath:indexPath];
   PTLCollectionViewSupplementaryViewConfigBlock block = [self collectionViewSupplementaryViewConfigBlockForIndexPath:indexPath elementKind:kind];
   if (block != nil) {
      block(collectionView, view, indexPath, kind);
   }
   return view;
}

@end
