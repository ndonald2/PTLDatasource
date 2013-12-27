//
//  PTLMutableIndexPathMapping.m
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import "PTLMutableIndexPathMapping.h"
#import "NSMutableIndexSet+PTLDatasource.h"
#import "NSArray+PTLDatasource.h"

@interface PTLMutableIndexPathMapping ()

@property (nonatomic, readwrite, strong) NSMutableArray *mutableItemIndeciesBySection;

@property (nonatomic, assign) BOOL immutableDataNeedsRefresh;
@property (nonatomic, readwrite, strong) NSArray *itemIndeciesBySection;

@end

@implementation PTLMutableIndexPathMapping

#pragma mark - Properties

- (NSArray *)itemIndeciesBySection {
    if (self.immutableDataNeedsRefresh) {
        self.itemIndeciesBySection = [self.mutableItemIndeciesBySection ptl_deepCopy];
        self.immutableDataNeedsRefresh = NO;
    }
    return super.itemIndeciesBySection;
}

#pragma mark - Lifecycle

- (instancetype)initWithMapping:(PTLIndexPathMapping *)mapping {
	self = [super initWithMapping:mapping];
	if (self) {
	    _mutableItemIndeciesBySection = [self.itemIndeciesBySection ptl_mutableDeepCopy];
	}

	return self;
}

- (instancetype)initWithFilter:(NSPredicate *)filter datasource:(id<PTLDatasource>)datasource {
	self = [super initWithFilter:filter datasource:datasource];
	if (self) {
	    _mutableItemIndeciesBySection = [self.itemIndeciesBySection ptl_mutableDeepCopy];
	}

	return self;
}

#pragma mark - Mutability

- (NSUInteger)addSection:(NSUInteger)sectionIndex toDatasource:(id<PTLDatasource>)mappedDatasource {
    NSParameterAssert(sectionIndex >= 0 &&
                      sectionIndex <= self.mutableItemIndeciesBySection.count);

    NSArray *sourceItems = [mappedDatasource allItemsInSection:sectionIndex];
    NSIndexSet *itemIndecies = [sourceItems indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[self class] evaluateFilter:self.filter onItem:obj];
    }];

    [self.mutableItemIndeciesBySection insertObject:[itemIndecies mutableCopy] atIndex:sectionIndex];
    self.immutableDataNeedsRefresh = YES;
    return sectionIndex;
}

- (NSIndexPath *)addItemAtIndexPath:(NSIndexPath *)indexPath toDatasource:(id<PTLDatasource>)mappedDatasource {
    NSParameterAssert(indexPath.section >= 0 &&
                      indexPath.section <= self.mutableItemIndeciesBySection.count);

    id obj = [mappedDatasource itemAtIndexPath:indexPath];
    if (![[self class] evaluateFilter:self.filter onItem:obj]) {
        // Item doesn't pass through the filter, no need to update the mapping
        return nil;
    }
    NSMutableIndexSet *itemIndecies = [self.mutableItemIndeciesBySection objectAtIndex:indexPath.section];
    [itemIndecies addIndex:indexPath.item];
    self.immutableDataNeedsRefresh = YES;
    return [self indexPathForDatasourceIndexPath:indexPath];
}

- (NSUInteger)removeSection:(NSUInteger)sectionIndex fromDatasource:(id<PTLDatasource>)mappedDatasource {
    NSParameterAssert(sectionIndex < self.mutableItemIndeciesBySection.count);

    [self.mutableItemIndeciesBySection removeObjectAtIndex:sectionIndex];
    self.immutableDataNeedsRefresh = YES;
    return sectionIndex;
}

- (NSIndexPath *)removeItemAtIndexPath:(NSIndexPath *)indexPath fromDatasource:(id<PTLDatasource>)mappedDatasource {
    NSIndexPath *translatedIndexPath = [self indexPathForDatasourceIndexPath:indexPath];
    if (translatedIndexPath == nil) {
        return nil;
    }

    NSParameterAssert(indexPath.section < self.mutableItemIndeciesBySection.count);
    NSMutableIndexSet *itemIndecies = [self.mutableItemIndeciesBySection objectAtIndex:indexPath.section];

    NSParameterAssert(indexPath.item < itemIndecies.count);
    [itemIndecies ptl_removeIndexValueAtIndex:indexPath.item];
    self.immutableDataNeedsRefresh = YES;
    return translatedIndexPath;
}

@end
