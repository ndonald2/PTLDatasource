//
//  PTLCompositeDatasource.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLCompositeDatasource.h"
#import "PTLTableViewDatasource.h"
#import "PTLCollectionViewDatasource.h"

@interface PTLCompositeDatasource ()

@property (nonatomic, strong) NSMutableArray *datasources;
@property (nonatomic, strong) NSDictionary *datasourceToSectionRange;

@end

@implementation PTLCompositeDatasource

- (id)initWithWithDatasources:(NSArray *)datasources {
	self = [super init];
	if (self) {
	    _datasources = [datasources mutableCopy];
       for (id<PTLDatasource> datasource in datasources) {
           NSParameterAssert([datasource conformsToProtocol:@protocol(PTLDatasource)]);
           if ([datasource conformsToProtocol:@protocol(PTLObservableDatasource)]) {
               [(id<PTLObservableDatasource>)datasource addChangeObserver:self];
           }
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

#pragma mark - PTLDatasource

- (NSInteger)numberOfSections {
    NSInteger count = 0;
    for (id<PTLDatasource> datasource in self.datasources) {
        count += [datasource numberOfSections];
    }
    return count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    NSParameterAssert(sectionIndex >= 0 &&
                      sectionIndex < [self numberOfSections]);
    id<PTLDatasource> datasource = [self childDatasourceContainingSectionIndex:sectionIndex];
    return [datasource numberOfItemsInSection:[self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex]];
}

- (NSArray *)allItemsInSection:(NSInteger)sectionIndex {
    NSParameterAssert(sectionIndex >= 0 &&
                      sectionIndex < [self numberOfSections]);
    id<PTLDatasource> datasource = [self childDatasourceContainingSectionIndex:sectionIndex];
    return [datasource allItemsInSection:[self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex]];
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

#pragma mark - PTLDatasourceContainer

- (NSInteger)numberOfChildDatasources {
   return self.datasources.count;
}

- (id<PTLDatasource>)childDatasourceAtIndex:(NSInteger)datasourceIndex {
   return [self.datasources objectAtIndex:datasourceIndex];
}

- (NSIndexSet *)sectionIndicesForDescendantDatasource:(id<PTLDatasource>)datasource {
   if ([self.datasources containsObject:datasource]) {
      NSRange sectionRange = [[self.datasourceToSectionRange objectForKey:datasource] rangeValue];
      return [NSIndexSet indexSetWithIndexesInRange:sectionRange];
   } else {
      for (id<PTLDatasource> childDatasource in self.datasources) {
         if ([childDatasource conformsToProtocol:@protocol(PTLDatasourceContainer)]) {
            NSIndexSet *indices = [(id<PTLDatasourceContainer>)childDatasource sectionIndicesForDescendantDatasource:datasource];
            if (indices.count > 0) {
               NSInteger offset = [self resolvedSectionIndexForChildDatasource:childDatasource sectionIndex:0];
               NSMutableIndexSet *resolvedIndicies = [indices mutableCopy];
               [resolvedIndicies shiftIndexesStartingAtIndex:[resolvedIndicies firstIndex] by:offset];
               return [resolvedIndicies copy];
            }
         }
      }
   }
   return [NSIndexSet indexSet];
}

- (id<PTLDatasource>)descendantDatasourceContainingSectionIndex:(NSInteger)sectionIndex {
   id<PTLDatasource> childDatasource = [self childDatasourceContainingSectionIndex:sectionIndex];
   if ([childDatasource conformsToProtocol:@protocol(PTLDatasourceContainer)]) {
      NSInteger childSectionIndex = [self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex];
      return [(id<PTLDatasourceContainer>)childDatasource descendantDatasourceContainingSectionIndex:childSectionIndex];
   }
   return childDatasource;
}

#pragma mark - Lookup

- (BOOL)containsItem:(id)item {
   for (id<PTLDatasource> datasource in self.datasources) {
      if ([datasource containsItem:item]) {
         return YES;
      }
   }
   return NO;
}

- (NSIndexPath *)indexPathOfItem:(id)item {
   for (id<PTLDatasource> datasource in self.datasources) {
      NSIndexPath *indexPath = [datasource indexPathOfItem:item];
      if (indexPath != nil) {
         return [self resolvedIndexPathForChildDatasource:datasource indexPath:indexPath];
      }
   }
   return nil;
}

- (NSArray *)allItems {
   NSMutableArray *results = [NSMutableArray array];
   for (id<PTLDatasource> datasource in self.datasources) {
      [results addObjectsFromArray:[datasource allItems]];
   }
   return results;
}

- (NSInteger)numberOfItems {
   NSInteger count = 0;
   for (id<PTLDatasource> datasource in self.datasources) {
      count += [datasource numberOfItems];
   }
   return count;
}

@end
