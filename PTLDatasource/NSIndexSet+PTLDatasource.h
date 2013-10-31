//
//  NSIndexSet+PTLDatasource.h
//  PTLDatasource
//
//  Created by Brian Partridge on 10/30/13.
//
//

#import <Foundation/Foundation.h>

@interface NSIndexSet (PTLDatasource)

- (NSUInteger)ptl_indexValueAtIndex:(NSUInteger)targetIndex;
- (NSUInteger)ptl_indexOfIndexValue:(NSUInteger)indexValue;

@end
