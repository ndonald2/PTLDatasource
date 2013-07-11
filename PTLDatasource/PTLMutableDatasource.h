//
//  PTLMutableDatasource.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasource.h"

typedef NS_ENUM(NSInteger, PTLChangeType) {
   PTLChangeTypeAdd,
   PTLChangeTypeRemove,
   PTLChangeTypeMove,
   PTLChangeTypeUpdate,
};

@protocol PTLMutableDatasource <PTLDatasource>

- (void)beginChanges;
- (void)endChanges;

#pragma mark - Item Changes

- (void)addObject:(id)object toSection:(NSInteger)sectionIndex;
- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

- (void)removeObject:(id)object;
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

- (void)moveObjectAtIndexPath:(NSIndexPath *)start toIndexPath:(NSIndexPath *)end;

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

- (BOOL)canPerformChange:(PTLChangeType)change sourceIndexPath:(NSIndexPath *)sourceIndexPath destinationIndexPath:(NSIndexPath *)destinationIndexPath;

#pragma mark - Section Changes

- (void)addSection;
- (void)insertSectionAtIndex:(NSInteger)sectionIndex;

- (void)removeSectionAtIndex:(NSInteger)sectionIndex;

- (void)moveSectionAtIndex:(NSInteger)startIndex toIndex:(NSInteger)endIndex;

- (void)replaceSectionAtIndex:(NSInteger)startIndex;

- (BOOL)canPerformSectionChange:(PTLChangeType)change sourceIndex:(NSInteger)sourceIndex destinationIndex:(NSInteger)destinationIndex;

@end
