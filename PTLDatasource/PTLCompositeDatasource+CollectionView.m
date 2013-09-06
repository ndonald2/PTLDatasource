//
//  PTLCompositeDatasource+CollectionView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 8/25/13.
//
//

#import "PTLCompositeDatasource+CollectionView.h"

@interface PTLCompositeDatasource (Private_Helpers)

- (NSInteger)resolvedChildDatasourceSectionIndexForSectionIndex:(NSInteger)sectionIndex;
- (NSIndexPath *)resolvedChildDatasourceIndexPathForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PTLCompositeDatasource (CollectionView)

- (NSString *)collectionViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
   NSString *result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
       [datasource respondsToSelector:@selector(collectionViewCellIdentifierForIndexPath:)]) {
      id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      result = [collectionViewDatasource collectionViewCellIdentifierForIndexPath:resolvedIndexPath];
   }
   return (result) ?: self.collectionViewCellIdentifier;
}

- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
   PTLCollectionViewCellConfigBlock result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
       [datasource respondsToSelector:@selector(collectionViewCellConfigBlockForIndexPath:)]) {
      id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      result = [collectionViewDatasource collectionViewCellConfigBlockForIndexPath:resolvedIndexPath];
   }
   return (result) ?: self.collectionViewCellConfigBlock;
}

- (NSString *)collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind {
   NSString *result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
       [datasource respondsToSelector:@selector(collectionViewSupplementaryViewIdentifierForIndexPath:elementKind:)]) {
      id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      result = [collectionViewDatasource collectionViewSupplementaryViewIdentifierForIndexPath:resolvedIndexPath elementKind:elementKind];
   }
   return (result) ?: [super collectionViewSupplementaryViewIdentifierForIndexPath:indexPath elementKind:elementKind];
}

- (PTLCollectionViewSupplementaryViewConfigBlock)composite_collectionViewSupplementaryViewConfigBlockForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind {
   PTLCollectionViewSupplementaryViewConfigBlock result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
       [datasource respondsToSelector:@selector(collectionViewSupplementaryViewConfigBlockForIndexPath:elementKind:)]) {
      id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      result = [collectionViewDatasource collectionViewSupplementaryViewConfigBlockForIndexPath:resolvedIndexPath elementKind:elementKind];
   }
   return (result) ?: [super collectionViewSupplementaryViewConfigBlockForIndexPath:indexPath elementKind:elementKind];
}

@end
