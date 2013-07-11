//
//  PTLTableViewDatasourceAdapter.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLTableViewDatasourceAdapter.h"
#import <objc/runtime.h>

@interface PTLTableViewDatasourceAdapter ()

@property (nonatomic, strong) id<PTLTableViewDatasource> datasource;

@end

#pragma clang diagnostic ignored "-Wprotocol"

@implementation PTLTableViewDatasourceAdapter

- (id)initWithDatasource:(id<PTLTableViewDatasource>)datasource {
	self = [super init];
	if (self) {
        _datasource = datasource;
        [_datasource addChangeObserver:self];
	}

	return self;
}

#pragma mark - PTLDatasource
#pragma mark - PTLTableViewDatasource

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, @selector(numberOfSections)) ||
        sel_isEqual(aSelector, @selector(numberOfItemsInSection:)) ||
        sel_isEqual(aSelector, @selector(itemAtIndexPath:)) ||
        sel_isEqual(aSelector, @selector(titleForSection:)) ||
        sel_isEqual(aSelector, @selector(subtitleForSection:)) ||
        sel_isEqual(aSelector, @selector(tableViewCellIdentifierForIndexPath:)) ||
        sel_isEqual(aSelector, @selector(tableViewCellConfigBlockForIndexPath:))) {
        return self.datasource;
    }
    return nil;
}

#pragma mark - UITableViewDatasource Required Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datasource numberOfItemsInSection:section];
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
    return [self.datasource numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    return [self.datasource titleForSection:sectionIndex];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex {
    return [self.datasource subtitleForSection:sectionIndex];
}

#pragma mark - PTLDatasourceObserver

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change sourceIndexPath:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath {
   [self notifyObserversOfChange:change sourceIndexPath:sourceIndexPath destinationIndexPath:destinationIndexPath];
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change sectionIndex:(NSInteger)sectionIndex {
   [self notifyObserversOfSectionChange:change sectionIndex:sectionIndex];
}

@end
