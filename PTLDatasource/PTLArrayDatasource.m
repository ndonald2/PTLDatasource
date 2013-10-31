//
//  PTLArraySection.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLArrayDatasource.h"

@interface PTLArrayDatasource ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation PTLArrayDatasource

- (id)initWithItems:(NSArray *)items {
    NSParameterAssert(items != nil);
	self = [super init];
	if (self) {
	    _items = [items mutableCopy];
	}

	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - PTLDatasource

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    NSParameterAssert(sectionIndex >= 0 &&
                      sectionIndex < [self numberOfSections]);
    return self.items.count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    NSParameterAssert(indexPath.item >= 0 &&
                      indexPath.item < [self numberOfItemsInSection:indexPath.section]);
    return [self.items objectAtIndex:indexPath.item];
}

#pragma mark - Mutability

#pragma mark - Insert

- (void)addItem:(id)item {
    NSParameterAssert(item != nil);
    [self addItemsFromArray:@[item]];
}

- (void)addItemsFromArray:(NSArray *)items {
    [self notifyObserversOfChangesBeginning];
    NSInteger start = self.items.count;
    [self.items addObjectsFromArray:items];
    NSInteger end = self.items.count;
    for (int i = start; i < end; i++) {
        [self notifyObserversOfChange:PTLChangeTypeInsert
                          atIndexPath:nil
                         newIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    [self notifyObserversOfChangesEnding];
}

- (void)insertItem:(id)item atIndex:(NSInteger)index {
    NSParameterAssert(index >= 0 &&
                      index <= self.items.count);
    [self notifyObserversOfChangesBeginning];
    [self.items insertObject:item atIndex:index];
    [self notifyObserversOfChange:PTLChangeTypeInsert
                      atIndexPath:nil
                     newIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [self notifyObserversOfChangesEnding];
}

#pragma mark - Remove

- (void)removeItem:(id)item {
    NSInteger index = [self.items indexOfObject:item];
    if (index == NSNotFound) {
        return;
    }
    [self removeItemAtIndex:index];
}

- (void)removeItemAtIndex:(NSInteger)index {
    NSParameterAssert(index >= 0 &&
                      index < self.items.count);
    [self notifyObserversOfChangesBeginning];
    [self.items removeObjectAtIndex:index];
    [self notifyObserversOfChange:PTLChangeTypeRemove
                      atIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                     newIndexPath:nil];
    [self notifyObserversOfChangesEnding];
}

- (void)removeAllItems {
    [self notifyObserversOfChangesBeginning];
    NSInteger end = self.items.count;
    [self.items removeAllObjects];
    for (int i = 0; i < end; i++) {
        [self notifyObserversOfChange:PTLChangeTypeRemove
                          atIndexPath:[NSIndexPath indexPathForItem:i inSection:0]
                         newIndexPath:nil];
    }
    [self notifyObserversOfChangesEnding];
}

#pragma mark - Move

- (void)moveItemAtIndex:(NSInteger)startIndex toIndex:(NSInteger)endIndex {
    NSParameterAssert(startIndex >= 0 &&
                      startIndex < self.items.count);
    NSParameterAssert(endIndex >= 0 &&
                      endIndex < self.items.count);
    if (startIndex == endIndex) {
        return;
    }
    [self notifyObserversOfChangesBeginning];
    id item = self.items[startIndex];
    [self.items removeObjectAtIndex:startIndex];
    [self.items insertObject:item atIndex:endIndex];
    [self notifyObserversOfChange:PTLChangeTypeMove
                      atIndexPath:[NSIndexPath indexPathForItem:startIndex inSection:0]
                     newIndexPath:[NSIndexPath indexPathForItem:startIndex inSection:0]];
    [self notifyObserversOfChangesEnding];
}

#pragma mark - Update

- (void)replaceItemAtIndex:(NSInteger)index withItem:(id)item {
    NSParameterAssert(index >= 0 &&
                      index < self.items.count);
    [self notifyObserversOfChangesBeginning];
    [self.items replaceObjectAtIndex:index withObject:item];
    [self notifyObserversOfChange:PTLChangeTypeUpdate
                      atIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                     newIndexPath:nil];
    [self notifyObserversOfChangesEnding];
}

#pragma mark - Lookup

- (BOOL)containsItem:(id)item {
    return [self.items containsObject:item];
}

- (NSIndexPath *)indexPathOfItem:(id)item {
    NSInteger index = [self.items indexOfObject:item];
    return (index == NSNotFound) ? nil : [NSIndexPath indexPathForItem:index inSection:0];
}

- (NSArray *)allItems {
   return [self.items copy];
}

- (NSInteger)numberOfItems {
   return self.items.count;
}

@end
