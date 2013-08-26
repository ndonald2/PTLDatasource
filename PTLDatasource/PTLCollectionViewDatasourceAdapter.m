//
//  PTLCollectionViewDatasourceAdapter.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLCollectionViewDatasourceAdapter.h"
#import <objc/runtime.h>

@interface PTLCollectionViewDatasourceAdapter ()

@property (nonatomic, strong) id<PTLCollectionViewDatasource>datasource;

@end

#pragma clang diagnostic ignored "-Wprotocol"

@implementation PTLCollectionViewDatasourceAdapter

- (id)initWithDatasource:(id<PTLCollectionViewDatasource>)datasource {
	self = [super init];
	if (self) {
        _datasource = datasource;
        [_datasource addChangeObserver:self];
	}

	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - PTLDatasource

- (NSInteger)numberOfSections {
   return [self.datasource numberOfSections];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
   return [self.datasource numberOfItemsInSection:sectionIndex];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
   return [self.datasource itemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDatasource Required Methods


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.datasource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self.datasource collectionViewCellIdentifierForIndexPath:indexPath]
                                                                           forIndexPath:indexPath];
    PTLCollectionViewCellConfigBlock block = [self.datasource collectionViewCellConfigBlockForIndexPath:indexPath];
    if (block != nil) {
        block(collectionView, cell, [self.datasource itemAtIndexPath:indexPath], indexPath);
    }
    return cell;
}

#pragma mark - UICollectionViewDatasource Optional Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.datasource numberOfSections];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.datasource collectionViewSupplementaryViewIdentifierForIndexPath:indexPath elementKind:kind];
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:identifier
                                                                               forIndexPath:indexPath];
    PTLCollectionViewSupplementaryViewConfigBlock block = [self.datasource collectionViewSupplementaryViewConfigBlockForIndexPath:indexPath elementKind:kind];
    if (block != nil) {
        block(collectionView, view, indexPath, kind);
    }
    return view;
}

#pragma mark - PTLDatasourceObserver

- (void)datasourceWillChange:(id<PTLDatasource>)datasource {
   [self notifyObserversOfChangesBeginning];
}

- (void)datasourceDidChange:(id<PTLDatasource>)datasource {
   [self notifyObserversOfChangesEnding];
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
   [self notifyObserversOfChange:change atIndexPath:indexPath newIndexPath:newIndexPath];
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex {
   [self notifyObserversOfSectionChange:change atSectionIndex:sectionIndex];
}

#pragma mark - PTLDatasourceContainer

- (NSInteger)numberOfChildDatasources {
   return (self.datasource != nil) ? 1 : 0;
}

- (id<PTLDatasource>)childDatasourceAtIndex:(NSInteger)datasourceIndex {
   return (datasourceIndex == 0) ? self.datasource : nil;
}

- (NSIndexSet *)sectionIndicesForDescendantDatasource:(id<PTLDatasource>)datasource {
   if (self.datasource == datasource) {
      return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfSections])];
   } else if ([self.datasource conformsToProtocol:@protocol(PTLDatasourceContainer)]) {
      return [(id<PTLDatasourceContainer>)self.datasource sectionIndicesForDescendantDatasource:datasource];
   }
   return [NSIndexSet indexSet];
}

- (id<PTLDatasource>)descendantDatasourceContainingSectionIndex:(NSInteger)sectionIndex {
   if (sectionIndex >= [self numberOfSections]) {
      return nil;
   } else if ([self.datasource conformsToProtocol:@protocol(PTLDatasourceContainer)]) {
      return [(id<PTLDatasourceContainer>)self.datasource descendantDatasourceContainingSectionIndex:sectionIndex];
   }
   return self.datasource;
}

@end
