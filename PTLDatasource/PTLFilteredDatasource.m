//
//  PTLFilteredDatasource.m
//  PTLDatasource
//
//  Created by Brian Partridge on 10/30/13.
//
//

#import "PTLFilteredDatasource.h"
#import "NSIndexSet+PTLDatasource.h"
#import "PTLDatasourceContainer.h"
#import "PTLMutableIndexPathMapping.h"

@interface PTLFilteredDatasource () <PTLDatasourceContainer>

@property (nonatomic, strong) id<PTLDatasource> sourceDatasource;
@property (nonatomic, strong) PTLIndexPathMapping *mapping;
@property (nonatomic, strong) PTLMutableIndexPathMapping *mutableMapping;

@end

@implementation PTLFilteredDatasource

#pragma mark - Properties

- (void)setFilter:(NSPredicate *)filter {
    if (filter == _filter) {
        return;
    }

    _filter = filter;

    PTLIndexPathMapping *before = self.mapping;
    PTLIndexPathMapping *after = [[PTLIndexPathMapping alloc] initWithFilter:filter datasource:self.sourceDatasource];
    PTLIndexPathMappingDelta *delta = [after deltaFromMapping:before];

    self.mapping = after;
    [self notifyObserversOfFilterChanges:delta];
}

#pragma mark - Lifecycle

- (instancetype)initWithDatasource:(id<PTLDatasource>)datasource filter:(NSPredicate *)filter {
	self = [super init];
	if (self) {
	    _sourceDatasource = datasource;
        NSParameterAssert([datasource conformsToProtocol:@protocol(PTLDatasource)]);
        if ([datasource conformsToProtocol:@protocol(PTLObservableDatasource)]) {
            [(id<PTLObservableDatasource>)datasource addChangeObserver:self];
        }
        _filter = filter;
        _mapping = [[PTLIndexPathMapping alloc] initWithFilter:filter datasource:datasource];
	}

	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - PTLDatasource

- (NSInteger)numberOfSections {
    return self.mapping.itemIndeciesBySection.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    NSParameterAssert(sectionIndex >= 0 &&
                      sectionIndex < [self numberOfSections]);

    NSIndexSet *indecies = [self.mapping.itemIndeciesBySection objectAtIndex:sectionIndex];
    return indecies.count;
}

- (NSArray *)allItemsInSection:(NSInteger)sectionIndex {
    NSParameterAssert(sectionIndex >= 0 &&
                      sectionIndex < [self numberOfSections]);

    NSIndexSet *itemIndecies = [self.mapping.itemIndeciesBySection objectAtIndex:sectionIndex];
    NSArray *allItemsInSourceSection = [self.sourceDatasource allItemsInSection:sectionIndex];
    return [allItemsInSourceSection objectsAtIndexes:itemIndecies];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *translatedIndexPath = [self.mapping datasourceIndexPathForIndexPath:indexPath];
    return [self.sourceDatasource itemAtIndexPath:translatedIndexPath];
}

#pragma mark - Lookup

- (BOOL)containsItem:(id)item {
    return ([self.sourceDatasource containsItem:item] &&
            [PTLIndexPathMapping evaluateFilter:self.filter onItem:item]);
}

- (NSIndexPath *)indexPathOfItem:(id)item {
    NSIndexPath *indexPath = [self.sourceDatasource indexPathOfItem:item];
    return [self.mapping indexPathForDatasourceIndexPath:indexPath];
}

- (NSArray *)allItems {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[self numberOfItems]];
    for (NSInteger i = 0; i < [self numberOfSections]; i++) {
        [results addObjectsFromArray:[self allItemsInSection:i]];
    }
    return [results copy];
}

- (NSInteger)numberOfItems {
    NSInteger count = 0;
    for (NSIndexSet *sourceItemIndecies in self.mapping.itemIndeciesBySection) {
        count += sourceItemIndecies.count;
    }
    return count;
}

#pragma mark - PTLDatasourceObserver

- (void)datasourceWillChange:(id<PTLDatasource>)datasource {
    [self notifyObserversOfChangesBeginning];
    self.mutableMapping = [self.mapping mutableCopy];
}

- (void)datasourceDidChange:(id<PTLDatasource>)datasource {

    self.mapping = [self.mutableMapping copy];
    self.mutableMapping = nil;
    [self notifyObserversOfChangesEnding];
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {

    switch(change) {
        case PTLChangeTypeInsert: {
            // Attempt to add the item and verify that there is a valid insertion indexpath.
            NSIndexPath *addedIndexPath = [self.mutableMapping addItemAtIndexPath:newIndexPath toDatasource:datasource];
            if (addedIndexPath != nil) {
                [self notifyObserversOfChange:change
                                  atIndexPath:nil
                                 newIndexPath:addedIndexPath];
            }
        }   break;

        case PTLChangeTypeRemove: {
            // Remove from mapping and verify there is a valid removal indexpath.
            NSIndexPath *removedIndexPath = [self.mutableMapping removeItemAtIndexPath:indexPath fromDatasource:datasource];
            if (removedIndexPath != nil) {
                [self notifyObserversOfChange:change
                                  atIndexPath:removedIndexPath
                                 newIndexPath:nil];
            }
        }   break;

        case PTLChangeTypeUpdate: {
            // Verify that the updated item has passed the filter before forwarding the update.
            NSIndexPath *updatedIndexPath = [self.mutableMapping indexPathForDatasourceIndexPath:indexPath];
            if (updatedIndexPath != nil) {
                [self notifyObserversOfChange:change
                                  atIndexPath:updatedIndexPath
                                 newIndexPath:nil];
            }
        }   break;

        case PTLChangeTypeMove: {
            // Remove from mapping and verify there is a valid removal indexpath before re-adding the item.
            NSIndexPath *removedIndexPath = [self.mutableMapping removeItemAtIndexPath:indexPath fromDatasource:datasource];
            if (removedIndexPath != nil) {
                NSIndexPath *addedIndexPath = [self.mutableMapping addItemAtIndexPath:newIndexPath toDatasource:datasource];
                [self notifyObserversOfChange:change
                                  atIndexPath:removedIndexPath
                                 newIndexPath:addedIndexPath];
            }
        }   break;
    }
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex {

    NSUInteger resultSectionIndex = NSNotFound;
    switch(change) {
        case PTLChangeTypeInsert:
            resultSectionIndex = [self.mutableMapping addSection:sectionIndex toDatasource:datasource];
            break;

        case PTLChangeTypeRemove:
            resultSectionIndex = [self.mutableMapping removeSection:sectionIndex fromDatasource:datasource];
            break;

        default:
            break;
    }

    [self notifyObserversOfSectionChange:change
                          atSectionIndex:resultSectionIndex];

}

#pragma mark - PTLDatasourceContainer

- (NSInteger)numberOfChildDatasources {
    return 1;
}

- (id<PTLDatasource>)childDatasourceAtIndex:(NSInteger)datasourceIndex {
    NSParameterAssert(datasourceIndex < [self numberOfChildDatasources]);
    return self.sourceDatasource;
}

- (NSIndexSet *)sectionIndicesForDescendantDatasource:(id<PTLDatasource>)datasource {
    NSInteger sectionCount = [self numberOfSections];
    if (sectionCount != 0) {
        if (datasource == self.sourceDatasource) {
            return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sectionCount)];
        } else if ([self.sourceDatasource conformsToProtocol:@protocol(PTLDatasourceContainer)]) {
            return [(id<PTLDatasourceContainer>)self.sourceDatasource sectionIndicesForDescendantDatasource:datasource];
        }
    }
    return [NSIndexSet indexSet];
}

- (id<PTLDatasource>)descendantDatasourceContainingSectionIndex:(NSInteger)sectionIndex {
    NSParameterAssert(sectionIndex < [self numberOfSections]);
    if ([self.sourceDatasource conformsToProtocol:@protocol(PTLDatasourceContainer)]) {
        return [(id<PTLDatasourceContainer>)self.sourceDatasource descendantDatasourceContainingSectionIndex:sectionIndex];
    }
    return self.sourceDatasource;
}

#pragma mark - Filtering

- (void)notifyObserversOfFilterChanges:(PTLIndexPathMappingDelta *)changes {
    [self notifyObserversOfChangesBeginning];

    for (NSInteger i = 0; i < changes.removedItemIndeciesBySection.count; i++) {
        NSIndexSet *removedIndecies = [changes.removedItemIndeciesBySection objectAtIndex:i];
        [removedIndecies enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:i];
            NSIndexPath *translatedIndexPath = [self.mapping indexPathForDatasourceIndexPath:indexPath];
            [self notifyObserversOfChange:PTLChangeTypeRemove atIndexPath:translatedIndexPath newIndexPath:nil];
        }];
    }

    for (NSInteger i = 0; i < changes.addedItemIndeciesBySection.count; i++) {
        NSIndexSet *addedIndecies = [changes.addedItemIndeciesBySection objectAtIndex:i];
        [addedIndecies enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:i];
            NSIndexPath *translatedIndexPath = [self.mapping indexPathForDatasourceIndexPath:indexPath];
            [self notifyObserversOfChange:PTLChangeTypeInsert atIndexPath:nil newIndexPath:translatedIndexPath];
        }];
    }

    [self notifyObserversOfChangesEnding];
}

@end
