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
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
       [datasource respondsToSelector:@selector(collectionViewCellIdentifierForIndexPath:)]) {
      id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      return [collectionViewDatasource collectionViewCellIdentifierForIndexPath:resolvedIndexPath];
   }
   return nil;
}

- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
       [datasource respondsToSelector:@selector(collectionViewCellConfigBlockForIndexPath:)]) {
      id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      return [collectionViewDatasource collectionViewCellConfigBlockForIndexPath:resolvedIndexPath];
   }
   return nil;
}

- (NSString *)collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind {
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
       [datasource respondsToSelector:@selector(collectionViewSupplementaryViewIdentifierForIndexPath:elementKind:)]) {
      id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      return [collectionViewDatasource collectionViewSupplementaryViewIdentifierForIndexPath:resolvedIndexPath elementKind:elementKind];
   }
   return nil;
}

- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlockForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind {
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
       [datasource respondsToSelector:@selector(collectionViewSupplementaryViewConfigBlockForIndexPath:elementKind:)]) {
      id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      return [collectionViewDatasource collectionViewSupplementaryViewConfigBlockForIndexPath:resolvedIndexPath elementKind:elementKind];
   }
   return nil;
}

@end
