//
//  PTLDatasource+Observation.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource+Observation.h"

@interface PTLDatasource (Observation_Private)

@property (nonatomic, strong) NSMutableSet *observers;

@end

@implementation PTLDatasource (Observation)

- (void)addChangeObserver:(id<PTLDatasourceObserver>)observer {
    if (self.observers == nil) {
        self.observers = [NSMutableSet setWithObject:observer];
    } else {
        [self.observers addObject:observer];
    }
}

- (void)removeChangeObserver:(id<PTLDatasourceObserver>)observer {
    [self.observers removeObject:observer];
}

- (void)removeAllObservers {
    [self.observers removeAllObjects];
}

- (void)notifyObserversOfChange:(PTLChangeType)change sourceIndexPath:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath {
    for (id<PTLDatasourceObserver> observer in self.observers) {
        if ([observer respondsToSelector:@selector(datasource:didChange:sourceIndexPath:destinationIndexPath:)]) {
            [observer datasource:self didChange:change sourceIndexPath:sourceIndexPath destinationIndexPath:destinationIndexPath];
        }
    }
}

@end
