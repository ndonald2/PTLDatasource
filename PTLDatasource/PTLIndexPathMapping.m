//
//  PTLIndexPathMapping.m
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import "PTLIndexPathMapping.h"
#import "NSMutableIndexSet+PTLDatasource.h"
#import "PTLMutableIndexPathMapping.h"

@interface PTLIndexPathMapping ()

@property (nonatomic, readwrite, strong) NSArray *itemIndeciesBySection;

@end

@implementation PTLIndexPathMapping

#pragma mark - Class Methods

+ (BOOL)evaluateFilter:(NSPredicate *)filter onItem:(id)item {
    return (filter == nil) ? YES : [filter evaluateWithObject:item];
}

+ (NSArray *)filter:(NSPredicate *)filter datasource:(id<PTLDatasource>)datasource {
    NSInteger numberOfSections = [datasource numberOfSections];
    NSMutableArray *mutableItemIndeciesBySection = [NSMutableArray arrayWithCapacity:numberOfSections];

    for (NSInteger sectionIndex = 0; sectionIndex < numberOfSections; sectionIndex++) {

        NSArray *sourceItems = [datasource allItemsInSection:sectionIndex];
        NSIndexSet *itemIndecies = [sourceItems indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [self evaluateFilter:filter onItem:obj];
        }];

        [mutableItemIndeciesBySection addObject:itemIndecies];
    }
    return [mutableItemIndeciesBySection copy];
}

+ (PTLIndexPathMappingDelta *)calculateDeltaFrom:(PTLIndexPathMapping *)fromMapping to:(PTLIndexPathMapping *)toMapping {
    NSParameterAssert(fromMapping.itemIndeciesBySection.count == toMapping.itemIndeciesBySection.count);

    NSInteger count = fromMapping.itemIndeciesBySection.count;
    NSMutableArray *removedItemIndeciesBySection = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *addedItemIndeciesBySection = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexSet *fromItemIndecies = [fromMapping.itemIndeciesBySection objectAtIndex:i];
        NSIndexSet *toItemIndecies = [toMapping.itemIndeciesBySection objectAtIndex:i];

        NSIndexSet *removedIndecies = [fromItemIndecies ptl_indeciesNotInIndexSet:toItemIndecies];
        [removedItemIndeciesBySection addObject:removedIndecies];
        NSIndexSet *addedIndecies = [toItemIndecies ptl_indeciesNotInIndexSet:fromItemIndecies];
        [addedItemIndeciesBySection addObject:addedIndecies];
    }

    PTLIndexPathMappingDelta *result = [[PTLIndexPathMappingDelta alloc] init];
    result.removedItemIndeciesBySection = [removedItemIndeciesBySection copy];
    result.addedItemIndeciesBySection = [addedItemIndeciesBySection copy];
    return result;
}

#pragma mark - Lifecycle

- (instancetype)initWithMapping:(PTLIndexPathMapping *)mapping {
	self = [super init];
	if (self) {
        _filter = [mapping.filter copy];
	    _itemIndeciesBySection = [mapping.itemIndeciesBySection copy];
	}

	return self;
}

- (instancetype)initWithFilter:(NSPredicate *)filter datasource:(id<PTLDatasource>)datasource {
	self = [super init];
	if (self) {
        _filter = filter;
        _itemIndeciesBySection = [[self class] filter:filter datasource:datasource];
	}

	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[PTLIndexPathMapping alloc] initWithMapping:self];
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[PTLMutableIndexPathMapping alloc] initWithMapping:self];
}

#pragma mark - Translation

- (NSIndexPath *)indexPathForDatasourceIndexPath:(NSIndexPath *)datasourceIndexPath {
    NSIndexSet *itemIndecies = [self.itemIndeciesBySection objectAtIndex:datasourceIndexPath.section];
    NSUInteger itemIndex = [itemIndecies ptl_indexOfIndexValue:datasourceIndexPath.item];
    if (itemIndex == NSNotFound) {
        return nil;
    }
    return [NSIndexPath indexPathForItem:itemIndex inSection:datasourceIndexPath.section];
}

- (NSIndexPath *)datasourceIndexPathForIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section >= 0 &&
                      indexPath.section < self.itemIndeciesBySection.count);
    NSIndexSet *itemIndecies = [self.itemIndeciesBySection objectAtIndex:indexPath.section];
    NSParameterAssert(indexPath.item >= 0 &&
                      indexPath.item < itemIndecies.count);

    NSUInteger datasourceItemIndex = [itemIndecies ptl_indexValueAtIndex:indexPath.item];
    return [NSIndexPath indexPathForItem:datasourceItemIndex inSection:indexPath.section];
}

#pragma mark - Delta

- (PTLIndexPathMappingDelta *)deltaToMapping:(PTLIndexPathMapping *)toMapping {
    return [[self class] calculateDeltaFrom:self to:toMapping];
}

- (PTLIndexPathMappingDelta *)deltaFromMapping:(PTLIndexPathMapping *)fromMapping {
    return [[self class] calculateDeltaFrom:fromMapping to:self];
}

@end
