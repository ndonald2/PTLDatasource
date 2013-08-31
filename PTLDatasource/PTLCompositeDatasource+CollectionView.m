//
//  PTLCompositeDatasource+CollectionView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 8/25/13.
//
//

#import "PTLCompositeDatasource+CollectionView.h"
#import "NSObject+PTLSwizzle.h"

@interface PTLCompositeDatasource (Private_Helpers)

- (NSInteger)resolvedChildDatasourceSectionIndexForSectionIndex:(NSInteger)sectionIndex;
- (NSIndexPath *)resolvedChildDatasourceIndexPathForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PTLCompositeDatasource (CollectionView)

+ (void)load {
   [self ptl_swizzleMethod:@selector(collectionViewCellIdentifierForIndexPath:) withMethod:@selector(composite_collectionViewCellIdentifierForIndexPath:)];
   [self ptl_swizzleMethod:@selector(collectionViewCellConfigBlockForIndexPath:) withMethod:@selector(composite_collectionViewCellConfigBlockForIndexPath:)];
   [self ptl_swizzleMethod:@selector(collectionViewSupplementaryViewIdentifierForIndexPath:elementKind:) withMethod:@selector(composite_collectionViewSupplementaryViewIdentifierForIndexPath:elementKind:)];
   [self ptl_swizzleMethod:@selector(collectionViewSupplementaryViewConfigBlockForIndexPath:elementKind:) withMethod:@selector(composite_collectionViewSupplementaryViewConfigBlockForIndexPath:elementKind:)];
}

- (NSString *)composite_collectionViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
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

- (PTLCollectionViewCellConfigBlock)composite_collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
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

- (NSString *)composite_collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind {
   NSString *result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
       [datasource respondsToSelector:@selector(collectionViewSupplementaryViewIdentifierForIndexPath:elementKind:)]) {
      id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      result = [collectionViewDatasource collectionViewSupplementaryViewIdentifierForIndexPath:resolvedIndexPath elementKind:elementKind];
   }
   return (result) ?: [self composite_collectionViewSupplementaryViewIdentifierForIndexPath:indexPath elementKind:elementKind];
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
   return (result) ?: [self composite_collectionViewSupplementaryViewConfigBlockForIndexPath:indexPath elementKind:elementKind];
}

@end
