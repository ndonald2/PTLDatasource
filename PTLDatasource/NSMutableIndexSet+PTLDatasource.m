//
//  NSMutableIndexSet+PTLDatasource.m
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import "NSMutableIndexSet+PTLDatasource.h"

@implementation NSMutableIndexSet (PTLDatasource)

- (void)ptl_removeIndexValueAtIndex:(NSUInteger)targetIndex {
    NSUInteger indexValue = [self ptl_indexValueAtIndex:targetIndex];
    [self removeIndex:indexValue];
}

@end
