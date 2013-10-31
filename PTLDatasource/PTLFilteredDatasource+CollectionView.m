//
//  PTLFilteredDatasource+CollectionView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import "PTLFilteredDatasource+CollectionView.h"
#import "PTLIndexPathMapping.h"

@interface PTLFilteredDatasource (Private_Helpers)

@property (nonatomic, strong) id<PTLDatasource> sourceDatasource;
@property (nonatomic, strong) PTLIndexPathMapping *mapping;

@end

@implementation PTLFilteredDatasource (CollectionView)

#pragma mark - Protocol Methods

- (NSString *)collectionViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    NSString *result = nil;
    if ([self.sourceDatasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
        [self.sourceDatasource respondsToSelector:@selector(collectionViewCellIdentifierForIndexPath:)]) {
        id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)self.sourceDatasource;
        NSIndexPath *resolvedIndexPath = [self.mapping datasourceIndexPathForIndexPath:indexPath];
        result = [collectionViewDatasource collectionViewCellIdentifierForIndexPath:resolvedIndexPath];
    }
    return (result) ?: self.collectionViewCellIdentifier;
}

- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    PTLCollectionViewCellConfigBlock result = nil;
    if ([self.sourceDatasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
        [self.sourceDatasource respondsToSelector:@selector(collectionViewCellConfigBlockForIndexPath:)]) {
        id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)self.sourceDatasource;
        NSIndexPath *resolvedIndexPath = [self.mapping datasourceIndexPathForIndexPath:indexPath];
        result = [collectionViewDatasource collectionViewCellConfigBlockForIndexPath:resolvedIndexPath];
    }
    return (result) ?: self.collectionViewCellConfigBlock;
}

- (NSString *)collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind {
    NSString *result = nil;
    if ([self.sourceDatasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
        [self.sourceDatasource respondsToSelector:@selector(collectionViewSupplementaryViewIdentifierForIndexPath:elementKind:)]) {
        id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)self.sourceDatasource;
        NSIndexPath *resolvedIndexPath = [self.mapping datasourceIndexPathForIndexPath:indexPath];
        result = [collectionViewDatasource collectionViewSupplementaryViewIdentifierForIndexPath:resolvedIndexPath elementKind:elementKind];
    }
    return (result) ?: [super collectionViewSupplementaryViewIdentifierForIndexPath:indexPath elementKind:elementKind];
}

- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlockForIndexPath:(NSIndexPath *)indexPath elementKind:(NSString *)elementKind {
    PTLCollectionViewSupplementaryViewConfigBlock result = nil;
    if ([self.sourceDatasource conformsToProtocol:@protocol(PTLCollectionViewDatasource)] &&
        [self.sourceDatasource respondsToSelector:@selector(collectionViewSupplementaryViewConfigBlockForIndexPath:elementKind:)]) {
        id<PTLCollectionViewDatasource> collectionViewDatasource = (id<PTLCollectionViewDatasource>)self.sourceDatasource;
        NSIndexPath *resolvedIndexPath = [self.mapping datasourceIndexPathForIndexPath:indexPath];
        result = [collectionViewDatasource collectionViewSupplementaryViewConfigBlockForIndexPath:resolvedIndexPath elementKind:elementKind];
    }
    return (result) ?: [super collectionViewSupplementaryViewConfigBlockForIndexPath:indexPath elementKind:elementKind];
}

@end
