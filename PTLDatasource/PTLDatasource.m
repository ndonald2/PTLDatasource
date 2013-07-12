//
//  PTLDatasource.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource.h"
#import <objc/runtime.h>

@implementation PTLDatasource

- (NSInteger)numberOfSections {
    return 0;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    return 0;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end

#pragma mark - Mutability Implementation

@implementation PTLDatasource (Mutability)

- (void)beginChanges {
   [self notifyObserversOfChangesBeginning];
}

- (void)endChanges {
   [self notifyObserversOfChangesEnding];
}

@end

#pragma mark - Observation Implementation

@interface WeakObserverWrapper : NSObject

@property (nonatomic, weak) id<PTLDatasourceObserver>observer;

+ (instancetype)wrapObserver:(id<PTLDatasourceObserver>)observer;

@end

@implementation WeakObserverWrapper

+ (instancetype)wrapObserver:(id<PTLDatasourceObserver>)observer {
   WeakObserverWrapper *wrapper = [[WeakObserverWrapper alloc] init];
   wrapper.observer = observer;
   return wrapper;
}

@end

@interface PTLDatasource (Observation_Private)

@property (nonatomic, readonly, strong) NSMutableArray *observers;

@end

@implementation PTLDatasource (Observation)

- (void)addChangeObserver:(id<PTLDatasourceObserver>)observer {
   [self.observers addObject:[WeakObserverWrapper wrapObserver:observer]];
}

- (void)removeChangeObserver:(id<PTLDatasourceObserver>)observer {
   NSArray *wrappersToRemove = [self.observers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(WeakObserverWrapper *wrapper, NSDictionary *bindings) {
      return (wrapper.observer == observer ||
              wrapper.observer == nil);
   }]];
   [self.observers removeObjectsInArray:wrappersToRemove];
}

- (void)removeAllObservers {
   [self.observers removeAllObjects];
}

- (void)notifyObserversOfChangesBeginning {
   for (WeakObserverWrapper *wrapper in self.observers) {
      if ([wrapper.observer respondsToSelector:@selector(datasourceWillChange:)]) {
         [wrapper.observer datasourceWillChange:self];
      }
   }
}

- (void)notifyObserversOfChangesEnding {
   for (WeakObserverWrapper *wrapper in self.observers) {
      if ([wrapper.observer respondsToSelector:@selector(datasourceDidChange:)]) {
         [wrapper.observer datasourceDidChange:self];
      }
   }
}

- (void)notifyObserversOfChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
   for (WeakObserverWrapper *wrapper in self.observers) {
      if ([wrapper.observer respondsToSelector:@selector(datasource:didChange:atIndexPath:newIndexPath:)]) {
         [wrapper.observer datasource:self didChange:change atIndexPath:indexPath newIndexPath:newIndexPath];
      }
   }
}

- (void)notifyObserversOfSectionChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex {
   for (WeakObserverWrapper *wrapper in self.observers) {
      if ([wrapper.observer respondsToSelector:@selector(datasource:didChange:atSectionIndex:)]) {
         [wrapper.observer datasource:self didChange:change atSectionIndex:sectionIndex];
      }
   }
}

@end

@implementation PTLDatasource (Observation_Private)

@dynamic observers;

- (NSMutableArray *)observers {
   NSMutableArray *result = objc_getAssociatedObject(self, @"observers");
   if (result == nil) {
      result = [NSMutableArray array];
      objc_setAssociatedObject(self, @"observers", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   }
   return result;
}



@end