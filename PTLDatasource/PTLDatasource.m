//
//  PTLDatasource.m
//  PTLDatasource
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource.h"
#import <objc/runtime.h>

#pragma mark - PTLDatasource

@interface PTLDatasource ()

@property (nonatomic, readonly, strong) NSHashTable *observers;

@end

@implementation PTLDatasource

#pragma mark - PTLItemDatasource

- (NSInteger)numberOfSections {
    return 0;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    NSAssert(NO, @"Invalid section index, there are no sections in the datasource.");
    return 0;
}

- (NSArray *)allItemsInSection:(NSInteger)sectionIndex {
    NSAssert(NO, @"Invalid section index, there are no sections in the datasource.");
    return @[];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)containsItem:(id)item {
    return NO;
}

- (NSIndexPath *)indexPathOfItem:(id)item {
    return nil;
}

- (NSArray *)allItems {
   return @[];
}

- (NSInteger)numberOfItems {
   return 0;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - PTLMutableDatasource

- (void)beginChanges {
   [self notifyObserversOfChangesBeginning];
}

- (void)endChanges {
   [self notifyObserversOfChangesEnding];
}

#pragma mark - PTLObservableDatasource

- (void)addChangeObserver:(id<PTLDatasourceObserver>)observer {
   [self.observers addObject:observer];
}

- (void)removeChangeObserver:(id<PTLDatasourceObserver>)observer {
   [self.observers removeObject:observer];
}

- (void)removeAllObservers {
   [self.observers removeAllObjects];
}

#pragma mark - Observation Helpers

@dynamic observers;

- (NSMutableArray *)observers {
    NSMutableArray *result = objc_getAssociatedObject(self, @"observers");
    if (result == nil) {
        result = [NSHashTable weakObjectsHashTable];
        objc_setAssociatedObject(self, @"observers", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

- (void)notifyObserversOfChangesBeginning {
   for (id observer in self.observers.allObjects) {
      if ([observer respondsToSelector:@selector(datasourceWillChange:)]) {
         [observer datasourceWillChange:self];
      }
   }
}

- (void)notifyObserversOfChangesEnding {
   for (id observer in self.observers.allObjects) {
      if ([observer respondsToSelector:@selector(datasourceDidChange:)]) {
         [observer datasourceDidChange:self];
      }
   }
}

- (void)notifyObserversOfChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
   for (id observer in self.observers.allObjects) {
      if ([observer respondsToSelector:@selector(datasource:didChange:atIndexPath:newIndexPath:)]) {
         [observer datasource:self didChange:change atIndexPath:indexPath newIndexPath:newIndexPath];
      }
   }
}

- (void)notifyObserversOfSectionChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex {
   for (id observer in self.observers.allObjects) {
      if ([observer respondsToSelector:@selector(datasource:didChange:atSectionIndex:)]) {
         [observer datasource:self didChange:change atSectionIndex:sectionIndex];
      }
   }
}

@end
