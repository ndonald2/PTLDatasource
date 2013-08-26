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

- (NSInteger)numberOfSections {
   return [self.datasource numberOfSections];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
   return [self.datasource numberOfItemsInSection:sectionIndex];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
   return [self.datasource itemAtIndexPath:indexPath];
}

#pragma mark - PTLTableViewDatasource

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
   return [self.datasource tableViewCellIdentifierForIndexPath:indexPath];
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
   return [self.datasource tableViewCellConfigBlockForIndexPath:indexPath];
}

- (NSString *)titleForSection:(NSInteger)sectionIndex {
   if ([self.datasource respondsToSelector:@selector(titleForSection:)]) {
      return [self.datasource tableViewHeaderTitleForSection:sectionIndex];
   }
   return nil;
}

- (NSString *)subtitleForSection:(NSInteger)sectionIndex {
   if ([self.datasource respondsToSelector:@selector(subtitleForSection:)]) {
      return [self.datasource tableViewFooterTitleForSection:sectionIndex];
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
    return [self.datasource tableViewHeaderTitleForSection:sectionIndex];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex {
    return [self.datasource tableViewFooterTitleForSection:sectionIndex];
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
