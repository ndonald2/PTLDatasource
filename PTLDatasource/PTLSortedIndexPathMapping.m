//
//  PTLSortedIndexPathMapping.m
//  PTLDatasource
//
//  Created by Brian Partridge on 12/26/13.
//
//

#import "PTLSortedIndexPathMapping.h"
#import "PTLMutableSortedIndexPathMapping.h"

@interface PTLSortedIndexPathMapping ()

@property (nonatomic, readwrite, strong) NSArray *sortedItemsBySection;
@property (nonatomic, readwrite, strong) NSArray *sortDescriptors;
@property (nonatomic, readwrite, strong) id<PTLDatasource> datasource;

@end

@implementation PTLSortedIndexPathMapping

#pragma mark - Class Methods

+ (NSArray *)sort:(NSArray *)sortDescriptors datasource:(id<PTLDatasource>)datasource {
    NSInteger numberOfSections = [datasource numberOfSections];
    NSMutableArray *mutableItemIndeciesBySection = [NSMutableArray arrayWithCapacity:numberOfSections];

    for (NSInteger sectionIndex = 0; sectionIndex < numberOfSections; sectionIndex++) {

        NSArray *sourceItems = [datasource allItemsInSection:sectionIndex];
        NSArray *sortedItems = [sourceItems sortedArrayUsingDescriptors:sortDescriptors];

        [mutableItemIndeciesBySection addObject:sortedItems];
    }
    return [mutableItemIndeciesBySection copy];
}

#pragma mark - Lifecycle

- (instancetype)initWithMapping:(PTLSortedIndexPathMapping *)mapping {
	self = [super init];
	if (self) {
        _sortDescriptors = [mapping.sortDescriptors copy];
        _sortedItemsBySection = [mapping.sortedItemsBySection copy];
        _datasource = mapping.datasource;
	}

	return self;
}

- (instancetype)initWithSortDescriptors:(NSArray *)sortDescriptors datasource:(id<PTLDatasource>)datasource {
	self = [super init];
	if (self) {
        _sortDescriptors = sortDescriptors;
        _sortedItemsBySection = [[self class] sort:sortDescriptors datasource:datasource];
        _datasource = datasource;
	}

	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[PTLSortedIndexPathMapping alloc] initWithMapping:self];
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[PTLMutableSortedIndexPathMapping alloc] initWithMapping:self];
}

#pragma mark - Translation

- (NSIndexPath *)indexPathForDatasourceIndexPath:(NSIndexPath *)datasourceIndexPath {
    id item = [self.datasource itemAtIndexPath:datasourceIndexPath];
    NSParameterAssert(datasourceIndexPath.section >= 0 &&
                      datasourceIndexPath.section < self.sortedItemsBySection.count);
    NSArray *sortedItems = [self.sortedItemsBySection objectAtIndex:datasourceIndexPath.section];
    NSUInteger sortedItemIndex = [sortedItems indexOfObject:item
                                        inSortedRange:NSMakeRange(0, sortedItems.count)
                                              options:kNilOptions
                                      usingComparator:PTLComparitorMake(self.sortDescriptors)];
    if (sortedItemIndex == NSNotFound) {
        return nil;
    }
    return [NSIndexPath indexPathForItem:sortedItemIndex inSection:datasourceIndexPath.section];
}

- (NSIndexPath *)datasourceIndexPathForIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section >= 0 &&
                      indexPath.section < self.sortedItemsBySection.count);
    NSArray *sortedItems = [self.sortedItemsBySection objectAtIndex:indexPath.section];
    NSParameterAssert(indexPath.item >= 0 &&
                      indexPath.item < sortedItems.count);
    id item = [sortedItems objectAtIndex:indexPath.item];
    NSArray *datasourceItemsInSection = [self.datasource allItemsInSection:indexPath.section];
    NSUInteger datasourceItemIndex = [datasourceItemsInSection indexOfObject:item];
    if (datasourceItemIndex == NSNotFound) {
        return nil;
    }
    return [NSIndexPath indexPathForItem:datasourceItemIndex inSection:indexPath.section];
}

@end

