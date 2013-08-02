//
//  PTLIndexSection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource.h"

@interface PTLIndexDatasource : PTLDatasource

- (id)initWithIndecies:(NSIndexSet *)indecies;

- (void)addIndexValue:(NSUInteger)indexValue;
- (void)addIndexValuesFromIndexSet:(NSIndexSet *)indexValues;

- (void)removeIndexValue:(NSUInteger)indexValue;
- (void)removeAllItems;

- (BOOL)containsIndexValue:(NSUInteger)indexValue;
- (NSIndexPath *)indexPathOfIndexValue:(NSUInteger)indexValue;

@end
