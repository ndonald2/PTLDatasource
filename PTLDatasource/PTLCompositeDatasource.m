//
//  PTLCompositeDatasource.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLCompositeDatasource.h"

@interface PTLCompositeDatasource ()

@property (nonatomic, strong) NSMutableArray *datasources;
@property (nonatomic, strong) NSDictionary *datasourceToSectionRange;

@end

@implementation PTLCompositeDatasource

- (id)initWithWithDatasources:(NSArray *)datasources {
	self = [super init];
	if (self) {
	    _datasources = [datasources mutableCopy];
       for (PTLDatasource *datasource in datasources) {
           NSParameterAssert([datasource isKindOfClass:[PTLDatasource class]]);
           [datasource addChangeObserver:self];
       }
       [self reloadSectionsFromDatasources];
	}

	return self;
}

#pragma mark - Helpers

- (void)reloadSectionsFromDatasources {
    NSMutableDictionary *datasourceToSectionRange = [NSMutableDictionary dictionary];

    NSInteger offset = 0;
    for (id<PTLDatasource> datasource in self.datasources) {
        NSRange sectionRange = NSMakeRange(offset, [datasource numberOfSections]);
        [datasourceToSectionRange setObject:[NSValue valueWithRange:sectionRange] forKey:datasource];
        offset = sectionRange.location + sectionRange.length;
    }

    self.datasourceToSectionRange = [datasourceToSectionRange copy];
}

- (id<PTLDatasource>)childDatasourceContainingSectionIndex:(NSInteger)sectionIndex {
   for (id<PTLDatasource> datasource in self.datasources) {
      NSRange sectionRange = [[self.datasourceToSectionRange objectForKey:datasource] rangeValue];
      if (sectionRange.location <= sectionIndex &&
          sectionIndex < sectionRange.location + sectionRange.length) {
         return datasource;
      }
   }
   return nil;
}

- (NSInteger)resolvedChildDatasourceSectionIndexForSectionIndex:(NSInteger)sectionIndex {
    id<PTLDatasource> datasource = [self childDatasourceContainingSectionIndex:sectionIndex];
    NSRange sectionRange = [[self.datasourceToSectionRange objectForKey:datasource] rangeValue];
    NSInteger resolvedChildSectionIndex = sectionIndex - sectionRange.location;
    return resolvedChildSectionIndex;
}

- (NSIndexPath *)resolvedChildDatasourceIndexPathForIndexPath:(NSIndexPath *)indexPath {
    NSInteger resolvedChildSectionIndex = [self resolvedChildDatasourceSectionIndexForSectionIndex:indexPath.section];
    NSIndexPath *resolvedChildIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:resolvedChildSectionIndex];
    return resolvedChildIndexPath;
}

- (NSInteger)resolvedSectionIndexForChildDatasource:(id<PTLDatasource>)datasource sectionIndex:(NSInteger)sectionIndex {
   NSRange sectionRange = [[self.datasourceToSectionRange objectForKey:datasource] rangeValue];
   NSInteger resolvedSectionIndex = sectionRange.location + sectionIndex;
   return resolvedSectionIndex;
}

- (NSIndexPath *)resolvedIndexPathForChildDatasource:(id<PTLDatasource>)datasource indexPath:(NSIndexPath *)indexPath {
   NSRange sectionRange = [[self.datasourceToSectionRange objectForKey:datasource] rangeValue];
   NSIndexPath *resolvedIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section + sectionRange.location];
   return resolvedIndexPath;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - PTLDatasource

- (NSInteger)numberOfSections {
    NSInteger count = 0;
    for (id<PTLDatasource> datasource in self.datasources) {
        count += [datasource numberOfSections];
    }
    return count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    id<PTLDatasource> datasource = [self childDatasourceContainingSectionIndex:sectionIndex];
    return [datasource numberOfItemsInSection:[self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex]];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    id<PTLDatasource> datasource = [self childDatasourceContainingSectionIndex:indexPath.section];
    NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
    return [datasource itemAtIndexPath:resolvedIndexPath];
}

#pragma mark - PTLDatasourceObserver

- (void)datasourceWillChange:(id<PTLDatasource>)datasource {
   [self notifyObserversOfChangesBeginning];
}

- (void)datasourceDidChange:(id<PTLDatasource>)datasource {
   [self notifyObserversOfChangesEnding];
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
   [self notifyObserversOfChange:change
                     atIndexPath:[self resolvedIndexPathForChildDatasource:datasource
                                                                 indexPath:indexPath]
                    newIndexPath:[self resolvedIndexPathForChildDatasource:datasource
                                                                 indexPath:newIndexPath]];
}

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex {
   [self notifyObserversOfSectionChange:change
                         atSectionIndex:[self resolvedSectionIndexForChildDatasource:datasource
                                                                        sectionIndex:sectionIndex]];
}

#pragma mark - PTLTableViewDatasource

- (NSString *)titleForSection:(NSInteger)sectionIndex {
    id datasource = [self childDatasourceContainingSectionIndex:sectionIndex];
    return [datasource titleForSection:[self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex]];
}

- (NSString *)subtitleForSection:(NSInteger)sectionIndex {
    id datasource = [self childDatasourceContainingSectionIndex:sectionIndex];
    return [datasource subtitleForSection:[self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex]];
}

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self childDatasourceContainingSectionIndex:indexPath.section];
    return [datasource tableViewCellIdentifierForIndexPath:[self resolvedChildDatasourceIndexPathForIndexPath:indexPath]];
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self childDatasourceContainingSectionIndex:indexPath.section];
    return [datasource tableViewCellConfigBlockForIndexPath:[self resolvedChildDatasourceIndexPathForIndexPath:indexPath]];
}

#pragma mark - PTLCollectionViewDatasource

- (NSString *)collectionViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self childDatasourceContainingSectionIndex:indexPath.section];
    return [datasource collectionViewCellIdentifierForIndexPath:indexPath];
}

- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self childDatasourceContainingSectionIndex:indexPath.section];
    return [datasource collectionViewCellConfigBlockForIndexPath:indexPath];
}

- (NSString *)collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self childDatasourceContainingSectionIndex:indexPath.section];
    return [datasource collectionViewSupplementaryViewIdentifierForIndexPath:indexPath];
}

- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self childDatasourceContainingSectionIndex:indexPath.section];
    return [datasource collectionViewSupplementaryViewConfigBlockForIndexPath:indexPath];
}

@end
