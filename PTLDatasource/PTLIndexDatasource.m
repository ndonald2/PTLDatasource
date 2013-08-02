//
//  PTLIndexSection.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLIndexDatasource.h"

@interface NSIndexSet (Indexing)

- (NSUInteger)ptl_indexValueAtIndex:(NSUInteger)targetIndex;
- (NSUInteger)ptl_indexOfIndexValue:(NSUInteger)indexValue;

@end

@implementation NSIndexSet (Indexing)

- (NSUInteger)ptl_indexValueAtIndex:(NSUInteger)targetIndex {
    NSUInteger indexValue = [self firstIndex];
    for (NSUInteger i = 0; i < targetIndex; i++){
        indexValue = [self indexGreaterThanIndex:i];
    }
    return indexValue;
}

- (NSUInteger)ptl_indexOfIndexValue:(NSUInteger)indexValue {
    if (![self containsIndex:indexValue]) {
        return NSNotFound;
    }

    __block NSUInteger indexCounter = 0;
    [self enumerateRangesUsingBlock:^(NSRange range, BOOL *stop) {
        if (indexValue >= range.location &&
            indexValue < NSMaxRange(range)) {
            // Found the value
            indexCounter += indexValue - range.location;
            *stop = YES;
        } else {
            indexCounter += range.length;
        }
    }];
    return indexCounter;
}

@end

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
                          atIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                         newIndexPath:nil];
    }];
    [self notifyObserversOfChangesEnding];
}

#pragma mark - Remove

- (void)removeIndexValue:(NSUInteger)indexValue {
    if (![self.indecies containsIndex:indexValue]) {
        return;
    }
    [self notifyObserversOfChangesBeginning];
    [self.indecies removeIndex:indexValue];
    [self notifyObserversOfChange:PTLChangeTypeRemove
                      atIndexPath:[self indexPathOfItem:@(indexValue)]
                     newIndexPath:nil];
    [self notifyObserversOfChangesEnding];
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

- (BOOL)containsItem:(id)item {
    if (![item isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    return [self containsIndexValue:((NSNumber *)item).integerValue];
}

- (NSIndexPath *)indexPathOfItem:(id)item {
    if (![item isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    return [self indexPathOfIndexValue:((NSNumber *)item).integerValue];
}

@end
