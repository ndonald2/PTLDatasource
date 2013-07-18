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
    return self.items.count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.items objectAtIndex:indexPath.item];
}

#pragma mark - Mutability

#pragma mark - Insert

- (void)addItem:(id)item {
    if (item == nil) {
        return;
    }
    [self addItemsFromArray:@[item]];
}

- (void)addItemsFromArray:(NSArray *)items {
    [self notifyObserversOfChangesBeginning];
    NSInteger start = self.items.count;
    [self.items addObjectsFromArray:items];
    NSInteger end = self.items.count;
    for (int i = start; i < end; i++) {
        [self notifyObserversOfChange:PTLChangeTypeInsert
                          atIndexPath:[NSIndexPath indexPathForItem:i inSection:0]
                         newIndexPath:nil];
    }
    [self notifyObserversOfChangesEnding];
}

- (void)insertItem:(id)item atIndex:(NSInteger)index {
    [self notifyObserversOfChangesBeginning];
    [self.items insertObject:item atIndex:index];
    [self notifyObserversOfChange:PTLChangeTypeInsert
                      atIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                     newIndexPath:nil];
    [self notifyObserversOfChangesEnding];
}

#pragma mark - Remove

- (void)removeItem:(id)item {
    NSInteger index = [self.items indexOfObject:item];
    [self removeItemAtIndex:index];
}

- (void)removeItemAtIndex:(NSInteger)index {
    if (index > self.items.count) {
        return;
    }
    [self notifyObserversOfChangesBeginning];
    [self.items removeObjectAtIndex:index];
    [self notifyObserversOfChange:PTLChangeTypeRemove
                      atIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                     newIndexPath:nil];
    [self notifyObserversOfChangesEnding];
}

- (void)removeAllItems {
    [self notifyObserversOfChangesBeginning];
    [self.items removeAllObjects];
    NSInteger end = self.items.count;
    for (int i = 0; i < end; i++) {
        [self notifyObserversOfChange:PTLChangeTypeRemove
                          atIndexPath:[NSIndexPath indexPathForItem:i inSection:0]
                         newIndexPath:nil];
    }
    [self notifyObserversOfChangesEnding];
}

#pragma mark - Move

- (void)moveItemAtIndex:(NSInteger)startIndex toIndex:(NSInteger)endIndex {
    [self notifyObserversOfChangesBeginning];
    id startItem = self.items[startIndex];
    self.items[startIndex] = self.items[endIndex];
    self.items[endIndex] = startItem;
    [self notifyObserversOfChange:PTLChangeTypeMove
                      atIndexPath:[NSIndexPath indexPathForItem:startIndex inSection:0]
                     newIndexPath:[NSIndexPath indexPathForItem:startIndex inSection:0]];
    [self notifyObserversOfChangesEnding];
}

#pragma mark - Update

- (void)replaceItemAtIndex:(NSInteger)index withItem:(id)item {
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

@end
