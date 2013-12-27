//
//  PTLMutableSortedIndexPathMapping.m
//  PTLDatasource
//
//  Created by Brian Partridge on 12/26/13.
//
//

#import "PTLMutableSortedIndexPathMapping.h"
#import "NSArray+PTLDatasource.h"

@interface PTLMutableSortedIndexPathMapping ()

@property (nonatomic, readwrite, strong) NSMutableArray *mutableSortedItemsBySection;

@property (nonatomic, assign) BOOL immutableDataNeedsRefresh;
@property (nonatomic, readwrite, strong) NSArray *sortedItemsBySection;

@end

@implementation PTLMutableSortedIndexPathMapping

#pragma mark - Properties

- (NSArray *)sortedItemsBySection {
    if (self.immutableDataNeedsRefresh) {
        self.sortedItemsBySection = [self.mutableSortedItemsBySection ptl_deepCopy];
        self.immutableDataNeedsRefresh = NO;
    }
    return super.sortedItemsBySection;
}

#pragma mark - Lifecycle

- (instancetype)initWithMapping:(PTLSortedIndexPathMapping *)mapping {
	self = [super initWithMapping:mapping];
	if (self) {
	    _mutableSortedItemsBySection = [self.sortedItemsBySection ptl_mutableDeepCopy];
	}

	return self;
}

- (instancetype)initWithSortDescriptors:(NSArray *)sortDescriptors datasource:(id<PTLDatasource>)datasource {
	self = [super initWithSortDescriptors:sortDescriptors datasource:datasource];
	if (self) {
	    _mutableSortedItemsBySection = [self.sortedItemsBySection ptl_mutableDeepCopy];
	}

	return self;
}

#pragma mark - Mutability

- (NSUInteger)addSection:(NSUInteger)sectionIndex toDatasource:(id<PTLDatasource>)mappedDatasource {
    NSParameterAssert(sectionIndex >= 0 &&
                      sectionIndex <= self.mutableSortedItemsBySection.count);

    NSArray *sourceItems = [mappedDatasource allItemsInSection:sectionIndex];
    NSArray *sortedItems = [sourceItems sortedArrayUsingDescriptors:self.sortDescriptors];

    [self.mutableSortedItemsBySection insertObject:[sortedItems mutableCopy] atIndex:sectionIndex];
    self.immutableDataNeedsRefresh = YES;
    return sectionIndex;
}

- (NSIndexPath *)addItemAtIndexPath:(NSIndexPath *)indexPath toDatasource:(id<PTLDatasource>)mappedDatasource {
    NSParameterAssert(indexPath.section >= 0 &&
                      indexPath.section <= self.mutableSortedItemsBySection.count);
    id item = [mappedDatasource itemAtIndexPath:indexPath];
    NSMutableArray *sortedItems = [self.mutableSortedItemsBySection objectAtIndex:indexPath.section];
    NSUInteger sortedInsertionIndex = [sortedItems indexOfObject:item
                                                   inSortedRange:NSMakeRange(0, sortedItems.count)
                                                         options:NSBinarySearchingInsertionIndex
                                                 usingComparator:PTLComparitorMake(self.sortDescriptors)];
    if (sortedInsertionIndex == NSNotFound) {
        return nil;
    }
    [sortedItems insertObject:item atIndex:sortedInsertionIndex];
    self.immutableDataNeedsRefresh = YES;
    return [NSIndexPath indexPathForItem:sortedInsertionIndex inSection:indexPath.section];
}

- (NSUInteger)removeSection:(NSUInteger)sectionIndex fromDatasource:(id<PTLDatasource>)mappedDatasource {
    NSParameterAssert(sectionIndex < self.mutableSortedItemsBySection.count);

    [self.mutableSortedItemsBySection removeObjectAtIndex:sectionIndex];
    self.immutableDataNeedsRefresh = YES;
    return sectionIndex;
}

- (NSIndexPath *)removeItemAtIndexPath:(NSIndexPath *)indexPath fromDatasource:(id<PTLDatasource>)mappedDatasource {
    NSIndexPath *translatedIndexPath = [self indexPathForDatasourceIndexPath:indexPath];
    if (translatedIndexPath == nil) {
        return nil;
    }

    NSParameterAssert(indexPath.section >= 0 &&
                      indexPath.section < self.mutableSortedItemsBySection.count);
    NSMutableArray *sortedItems = [self.mutableSortedItemsBySection objectAtIndex:indexPath.section];

    NSParameterAssert(indexPath.item >= 0 &&
                      indexPath.item < sortedItems.count);
    [sortedItems removeObjectAtIndex:indexPath.item];
    self.immutableDataNeedsRefresh = YES;
    return translatedIndexPath;
}

- (NSIndexPath *)updateItemAtIndexPath:(NSIndexPath *)indexPath fromDatasource:(id<PTLDatasource>)mappedDatasource {
    NSParameterAssert(indexPath.section >= 0 &&
                      indexPath.section < self.mutableSortedItemsBySection.count);
    
    id item = [mappedDatasource itemAtIndexPath:indexPath];

    NSMutableArray *sortedItems = [self.mutableSortedItemsBySection objectAtIndex:indexPath.section];
    [sortedItems removeObject:item];
    NSUInteger updatedIndex = [sortedItems indexOfObject:item
                                           inSortedRange:NSMakeRange(0, sortedItems.count)
                                                 options:NSBinarySearchingInsertionIndex
                                         usingComparator:PTLComparitorMake(self.sortDescriptors)];
    [sortedItems insertObject:item atIndex:updatedIndex];
    return [NSIndexPath indexPathForItem:updatedIndex inSection:indexPath.section];
}

@end
