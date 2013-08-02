//
//  PTLArraySection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource.h"

@interface PTLArrayDatasource : PTLDatasource

- (id)initWithItems:(NSArray *)items;

- (void)addItem:(id)item;
- (void)addItemsFromArray:(NSArray *)items;
- (void)insertItem:(id)item atIndex:(NSInteger)index;

- (void)removeItem:(id)item;
- (void)removeItemAtIndex:(NSInteger)index;
- (void)removeAllItems;

- (void)moveItemAtIndex:(NSInteger)startIndex toIndex:(NSInteger)endIndex;

- (void)replaceItemAtIndex:(NSInteger)index withItem:(id)item;

@end
