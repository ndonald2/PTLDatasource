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
@protocol PTLMutableDatasource;
@protocol PTLObservableDatasource;
@protocol PTLTableViewDatasource;
@protocol PTLCollectionViewDatasource;

#pragma mark - Datasource

@protocol PTLDatasource <NSObject, NSCopying>

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - Mutability

typedef NS_ENUM(NSInteger, PTLChangeType) {
   PTLChangeTypeInsert,
   PTLChangeTypeRemove,
   PTLChangeTypeMove,
   PTLChangeTypeUpdate,
};

@protocol PTLMutableDatasource <PTLDatasource>

- (void)beginChanges;
- (void)endChanges;

@optional

// Item Changes

- (void)addObject:(id)object toSection:(NSInteger)sectionIndex;
- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

- (void)removeObject:(id)object;
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

- (void)moveObjectAtIndexPath:(NSIndexPath *)start toIndexPath:(NSIndexPath *)end;

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

- (BOOL)canPerformChange:(PTLChangeType)change sourceIndexPath:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath;

// Section Changes

- (void)addSection;
- (void)insertSectionAtIndex:(NSInteger)sectionIndex;

- (void)removeSectionAtIndex:(NSInteger)sectionIndex;

- (void)moveSectionAtIndex:(NSInteger)startIndex toIndex:(NSInteger)endIndex;

- (void)replaceSectionAtIndex:(NSInteger)startIndex;

- (BOOL)canPerformSectionChange:(PTLChangeType)change sourceIndex:(NSInteger)sourceIndex destinationIndex:(NSInteger)destinationIndex;

@end

#pragma mark - Observation

@protocol PTLDatasourceObserver <NSObject>

- (void)datasourceWillChange:(id<PTLDatasource>)datasource;
- (void)datasourceDidChange:(id<PTLDatasource>)datasource;
- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath;
- (void)datasource:(id<PTLDatasource>)datasource didChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex;

@end

@protocol PTLObservableDatasource <PTLDatasource>

- (void)addChangeObserver:(id<PTLDatasourceObserver>)observer;
- (void)removeChangeObserver:(id<PTLDatasourceObserver>)observer;
- (void)removeAllObservers;

@end

#pragma mark - Datasource Implementation

@interface PTLDatasource : NSObject <PTLDatasource>

@end

#pragma mark - Mutability Implementation

@interface PTLDatasource (Mutability) <PTLMutableDatasource>

- (void)beginChanges;
- (void)endChanges;

@end

#pragma mark - Observation Implementation

@interface PTLDatasource (Observation) <PTLObservableDatasource>

- (void)addChangeObserver:(id<PTLDatasourceObserver>)observer;
- (void)removeChangeObserver:(id<PTLDatasourceObserver>)observer;
- (void)removeAllObservers;

- (void)notifyObserversOfChangesBeginning;
- (void)notifyObserversOfChangesEnding;
- (void)notifyObserversOfChange:(PTLChangeType)change atIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath;
- (void)notifyObserversOfSectionChange:(PTLChangeType)change atSectionIndex:(NSInteger)sectionIndex;

@end
