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
	}

	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - PTLDatasource
#pragma mark - PTLCollectionViewDatasource

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, @selector(numberOfSections)) ||
        sel_isEqual(aSelector, @selector(numberOfItemsInSection:)) ||
        sel_isEqual(aSelector, @selector(itemAtIndexPath:)) ||
        sel_isEqual(aSelector, @selector(collectionViewCellIdentifierForIndexPath:)) ||
        sel_isEqual(aSelector, @selector(collectionViewCellConfigBlockForIndexPath:)) ||
        sel_isEqual(aSelector, @selector(collectionViewSupplementaryViewIdentifierForIndexPath:)) ||
        sel_isEqual(aSelector, @selector(collectionViewSupplementaryViewConfigBlockForIndexPath:))) {
        return self.datasource;
    }
    return nil;
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
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:[self.datasource collectionViewSupplementaryViewIdentifierForIndexPath:indexPath]
                                                                               forIndexPath:indexPath];
    PTLCollectionViewSupplementaryViewConfigBlock block = [self.datasource collectionViewSupplementaryViewConfigBlockForIndexPath:indexPath];
    if (block != nil) {
        block(collectionView, view, indexPath);
    }
    return view;
}

@end
