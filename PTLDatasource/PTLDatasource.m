//
//  PTLDatasource.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource.h"
#import "PTLTableViewDatasourceSection.h"
#import "PTLCollectionViewDatasourceSection.h"

@interface PTLDatasource ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation PTLDatasource

- (id)initWithWithSections:(NSArray *)sections {
	self = [super init];
	if (self) {
	    _sections = sections;
	}

	return self;
}

#pragma mark - PTLDatasource

- (NSInteger)numberOfSections {
    return self.sections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    id<PTLDatasourceSection> section = [self.sections objectAtIndex:sectionIndex];
    return section.numberOfItems;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    id<PTLDatasourceSection> section = [self.sections objectAtIndex:indexPath.section];
    return [section itemAtIndex:indexPath.row];
}

#pragma mark - UITableViewDatasource Required Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<PTLTableViewDatasourceSection> section = [self.sections objectAtIndex:indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section.tableViewCellIdentifier forIndexPath:indexPath];
    if (section.tableViewCellConfigBlock != nil) {
        section.tableViewCellConfigBlock(tableView, cell, [self itemAtIndexPath:indexPath], indexPath);
    }
    return cell;
}

#pragma mark - UITableViewDatasource Optional Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    id<PTLDatasourceSection> section = [self.sections objectAtIndex:sectionIndex];
    return section.title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex {
    id<PTLDatasourceSection> section = [self.sections objectAtIndex:sectionIndex];
    return section.subtitle;
}

#pragma mark - UICollectionViewDatasource Required Methods


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<PTLCollectionViewDatasourceSection> section = [self.sections objectAtIndex:indexPath.section];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:section.collectionViewCellIdentifier
                                                                           forIndexPath:indexPath];
    if (section.collectionViewCellConfigBlock != nil) {
        section.collectionViewCellConfigBlock(collectionView, cell, [self itemAtIndexPath:indexPath], indexPath);
    }
    return cell;
}

#pragma mark - UICollectionViewDatasource Optional Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self numberOfSections];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    id<PTLCollectionViewDatasourceSection> section = [self.sections objectAtIndex:indexPath.section];
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:section.collectionViewSupplementaryViewIdentifier
                                                                               forIndexPath:indexPath];
    if (section.collectionViewSupplementaryViewConfigBlock != nil) {
        section.collectionViewSupplementaryViewConfigBlock(collectionView, view, indexPath);
    }
    return view;
}

@end
