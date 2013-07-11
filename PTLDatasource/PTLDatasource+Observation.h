//
//  PTLDatasource+Observation.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource.h"
#import "PTLMutableDatasource.h"

@protocol PTLDatasourceObserver <NSObject>

- (void)datasourceWillChange:(id<PTLDatasource>)datasource;
- (void)datasourceDidChange:(id<PTLDatasource>)datasource;
- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change sourceIndexPath:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change sectionIndex:(NSInteger)sectionIndex;

@end

@interface PTLDatasource (Observation)

- (void)addChangeObserver:(id<PTLDatasourceObserver>)observer;
- (void)removeChangeObserver:(id<PTLDatasourceObserver>)observer;
- (void)removeAllObservers;

- (void)notifyObserversOfChangesBeginning;
- (void)notifyObserversOfChangesEnding;
- (void)notifyObserversOfChange:(PTLChangeType)change sourceIndexPath:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)notifyObserversOfSectionChange:(PTLChangeType)change sectionIndex:(NSInteger)sectionIndex;

@end
