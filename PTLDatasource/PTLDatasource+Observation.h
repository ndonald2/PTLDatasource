//
//  PTLDatasource+Observation.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLMutableDatasource.h"

@protocol PTLDatasourceObserver <NSObject>

- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change sourceIndexPath:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@interface PTLDatasource (Observation)

- (void)addChangeObserver:(id<PTLDatasourceObserver>)observer;
- (void)removeChangeObserver:(id<PTLDatasourceObserver>)observer;
- (void)removeAllObservers;

- (void)notifyObserversOfChange:(PTLChangeType)change sourceIndexPath:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath;

@end
