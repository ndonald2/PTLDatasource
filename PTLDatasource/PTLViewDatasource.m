//
//  PTLDatasource.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLViewDatasource.h"
#import <objc/runtime.h>

@interface PTLViewDatasource ()

@property (nonatomic, strong) id<PTLViewDatasource> datasource;

@end

@implementation PTLViewDatasource

- (id)initWithDatasource:(id<PTLViewDatasource>)datasource {
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
#pragma mark - PTLTableViewDatasource
#pragma mark - PTLCollectionViewDatasource

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, @selector(numberOfSections)) ||
        sel_isEqual(aSelector, @selector(numberOfItemsInSection:)) ||
        sel_isEqual(aSelector, @selector(itemAtIndexPath:)) ||
        sel_isEqual(aSelector, @selector(titleForSection:)) ||
        sel_isEqual(aSelector, @selector(subtitleForSection:)) ||
        sel_isEqual(aSelector, @selector(tableViewCellIdentifierForIndexPath:)) ||
        sel_isEqual(aSelector, @selector(tableViewCellConfigBlockForIndexPath:)) ||
        sel_isEqual(aSelector, @selector(collectionViewCellIdentifierForIndexPath:)) ||
        sel_isEqual(aSelector, @selector(collectionViewCellConfigBlockForIndexPath:)) ||
        sel_isEqual(aSelector, @selector(collectionViewSupplementaryViewIdentifierForIndexPath:)) ||
        sel_isEqual(aSelector, @selector(collectionViewSupplementaryViewConfigBlockForIndexPath:))) {
        return self.datasource;
    }
    return nil;
}

#pragma mark - UITableViewDatasource Required Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.datasource tableViewCellIdentifierForIndexPath:indexPath]
                                                            forIndexPath:indexPath];
    PTLTableViewCellConfigBlock block = [self.datasource tableViewCellConfigBlockForIndexPath:indexPath];
    if (block != nil) {
        block(tableView, cell, [self.datasource itemAtIndexPath:indexPath], indexPath);
    }
    return cell;
}

#pragma mark - UITableViewDatasource Optional Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    return [self.datasource titleForSection:sectionIndex];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex {
    return [self.datasource subtitleForSection:sectionIndex];
}

#pragma mark - UICollectionViewDatasource Required Methods


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self.datasource collectionViewCellIdentifierForIndexPath:indexPath]
                                                                           forIndexPath:indexPath];
    PTLCollectionViewCellConfigBlock block = [self.datasource collectionViewCellConfigBlockForIndexPath:indexPath];
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
