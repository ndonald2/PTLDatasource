//
//  PTLDatasource+Observation.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource+Observation.h"
#import <objc/runtime.h>

@interface PTLDatasource (Observation_Private)

@property (nonatomic, readonly, strong) NSMutableSet *observers;

@end

@implementation PTLDatasource (Observation)

- (void)addChangeObserver:(id<PTLDatasourceObserver>)observer {
    [self.observers addObject:observer];
}

- (void)removeChangeObserver:(id<PTLDatasourceObserver>)observer {
    [self.observers removeObject:observer];
}

- (void)removeAllObservers {
    [self.observers removeAllObjects];
}

- (void)notifyObserversOfChangesBeginning {
    for (id<PTLDatasourceObserver> observer in self.observers) {
        if ([observer respondsToSelector:@selector(datasourceWillChange:)]) {
            [observer datasourceWillChange:self];
        }
    }
}

- (void)notifyObserversOfChangesEnding {
    for (id<PTLDatasourceObserver> observer in self.observers) {
        if ([observer respondsToSelector:@selector(datasourceDidChange:)]) {
            [observer datasourceDidChange:self];
        }
    }
}

- (void)notifyObserversOfChange:(PTLChangeType)change sourceIndexPath:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath {
    for (id<PTLDatasourceObserver> observer in self.observers) {
        if ([observer respondsToSelector:@selector(datasource:didChange:sourceIndexPath:destinationIndexPath:)]) {
            [observer datasource:self didChange:change sourceIndexPath:sourceIndexPath destinationIndexPath:destinationIndexPath];
        }
    }
}

- (void)notifyObserversOfSectionChange:(PTLChangeType)change sectionIndex:(NSInteger)sectionIndex {
    for (id<PTLDatasourceObserver> observer in self.observers) {
        if ([observer respondsToSelector:@selector(datasource:didChange:sectionIndex:)]) {
            [observer datasource:self didChange:change sectionIndex:sectionIndex];
        }
    }
}

@end

@implementation PTLDatasource (Observation_Private)

@dynamic observers;

- (NSMutableSet *)observers {
    NSMutableSet *result = objc_getAssociatedObject(self, @"observers");
    if (result == nil) {
        objc_setAssociatedObject(self, @"observers", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}



@end