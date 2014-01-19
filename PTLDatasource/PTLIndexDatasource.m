//
//  PTLIndexSection.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLIndexDatasource.h"
#import "NSIndexSet+PTLDatasource.h"

@interface PTLIndexDatasource ()

@property (nonatomic, strong) NSMutableIndexSet *indecies;

@end

@implementation PTLIndexDatasource

- (id)initWithIndecies:(NSIndexSet *)indecies {
	self = [super init];
	if (self) {
	    _indecies = [indecies mutableCopy];
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
    return self.indecies.count;
}

- (NSArray *)allItemsInSection:(NSInteger)sectionIndex {
    NSParameterAssert(sectionIndex >= 0 &&
                      sectionIndex < [self numberOfSections]);
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[self numberOfItemsInSection:sectionIndex]];
    [self.indecies enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        [results addObject:@(index)];
    }];
    return [results copy];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    NSParameterAssert(indexPath.item >= 0 &&
                      indexPath.item < [self numberOfItemsInSection:indexPath.section]);
    NSInteger index = [self.indecies ptl_indexValueAtIndex:indexPath.item];
    return (index == NSNotFound) ? nil : @(index);
}

#pragma mark - Mutability

#pragma mark - Insert

- (void)addIndexValue:(NSUInteger)indexValue {
    if ([self.indecies containsIndex:indexValue]) {
        return;
    }
    [self addIndexValuesFromIndexSet:[NSIndexSet indexSetWithIndex:indexValue]];
}

- (void)addIndexValuesFromIndexSet:(NSIndexSet *)indexValues {
    [self notifyObserversOfChangesBeginning];
    [indexValues enumerateIndexesUsingBlock:^(NSUInteger indexValue, BOOL *stop) {
        if ([self.indecies containsIndex:indexValue]) {
            return;
        }
        [self.indecies addIndex:indexValue];
        NSInteger index = [self.indecies ptl_indexOfIndexValue:indexValue];
        [self notifyObserversOfChange:PTLChangeTypeInsert
                          atIndexPath:nil
                         newIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    }];
    [self notifyObserversOfChangesEnding];
}

#pragma mark - Remove

- (void)removeIndexValue:(NSUInteger)indexValue {
    if (![self.indecies containsIndex:indexValue]) {
        return;
    }
    [self notifyObserversOfChangesBeginning];
    NSIndexPath *indexPath = [self indexPathOfItem:@(indexValue)];
    [self.indecies removeIndex:indexValue];
    [self notifyObserversOfChange:PTLChangeTypeRemove
                      atIndexPath:indexPath
                     newIndexPath:nil];
    [self notifyObserversOfChangesEnding];
}

- (void)removeIndexValueAtIndex:(NSUInteger)index {
    NSUInteger indexValue = [self indexValueAtIndex:index];
    [self removeIndexValue:indexValue];
}

- (void)removeAllItems {
    [self notifyObserversOfChangesBeginning];
    NSInteger count = self.indecies.count;
    [self.indecies removeAllIndexes];
    for (int i = 0; i < count; i++) {
        [self notifyObserversOfChange:PTLChangeTypeRemove
                          atIndexPath:[NSIndexPath indexPathForItem:i inSection:0]
                         newIndexPath:nil];
    }
    [self notifyObserversOfChangesEnding];
}

#pragma mark - Lookup

- (BOOL)containsIndexValue:(NSUInteger)indexValue {
    return [self.indecies containsIndex:indexValue];
}

- (NSIndexPath *)indexPathOfIndexValue:(NSUInteger)indexValue {
    NSInteger index = [self.indecies ptl_indexOfIndexValue:indexValue];
    return (index == NSNotFound) ? nil : [NSIndexPath indexPathForItem:index inSection:0];
}

- (NSUInteger)indexValueAtIndex:(NSUInteger)index {
    return [self.indecies ptl_indexValueAtIndex:index];
}

- (BOOL)containsItem:(id)item {
    if (![item isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    return [self containsIndexValue:((NSNumber *)item).unsignedIntegerValue];
}

- (NSIndexPath *)indexPathOfItem:(id)item {
    if (![item isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    return [self indexPathOfIndexValue:((NSNumber *)item).unsignedIntegerValue];
}

- (NSArray *)allItems {
   NSMutableArray *results = [NSMutableArray arrayWithCapacity:self.indecies.count];
   [self.indecies enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
      [results addObject:@(idx)];
   }];
   return [results copy];
}

- (NSInteger)numberOfItems {
   return self.indecies.count;
}

@end
