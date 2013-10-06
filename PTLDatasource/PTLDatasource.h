//
//  PTLDatasource
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTLDatasource;
@protocol PTLDatasource;
@protocol PTLItemDatasource;
@protocol PTLMutableDatasource;
@protocol PTLObservableDatasource;
@protocol PTLDatasourceObserver;

#pragma mark - Datasource

@protocol PTLDatasource <PTLMutableDatasource, PTLObservableDatasource, NSCopying>
@end

#pragma mark - Items

/// Adopted by an object containing a number of items in a number of sections.
@protocol PTLItemDatasource <NSObject>

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)containsItem:(id)item;
- (NSIndexPath *)indexPathOfItem:(id)item;
- (NSArray *)allItems;
- (NSInteger)numberOfItems;

@end

#pragma mark - Mutability

typedef NS_ENUM(NSInteger, PTLChangeType) {
   PTLChangeTypeInsert,
   PTLChangeTypeRemove,
   PTLChangeTypeMove,
   PTLChangeTypeUpdate,
};

/// Adopted by a datasource which provides methods to mutate the item collection.
/// Implementing these methods enables batching mutations into a set.
@protocol PTLMutableDatasource <PTLItemDatasource>

- (void)beginChanges;
- (void)endChanges;

@end

#pragma mark - Observation

/// Adopted by a datasource which will notify interested observers when the item collection changes.
@protocol PTLObservableDatasource <PTLItemDatasource>

- (void)addChangeObserver:(id<PTLDatasourceObserver>)observer;
- (void)removeChangeObserver:(id<PTLDatasourceObserver>)observer;
- (void)removeAllObservers;

@end

#pragma mark - Datasource Implementation

/// Abstract base class providing implementing basic mutability and observation logic.
@interface PTLDatasource : NSObject <PTLDatasource>

// Observation Helpers
- (void)notifyObserversOfChangesBeginning;
- (void)notifyObserversOfChangesEnding;
- (void)notifyObserversOfChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath;
- (void)notifyObserversOfSectionChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex;

@end

#pragma mark - Observer

@protocol PTLDatasourceObserver <NSObject>

- (void)datasourceWillChange:(id<PTLDatasource>)datasource;
- (void)datasourceDidChange:(id<PTLDatasource>)datasource;
- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath;
- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex;

@end
