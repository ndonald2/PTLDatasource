//
//  NSIndexSet+PTLDatasource.m
//  PTLDatasource
//
//  Created by Brian Partridge on 10/30/13.
//
//

#import "NSIndexSet+PTLDatasource.h"

@implementation NSIndexSet (PTLDatasource)

- (NSUInteger)ptl_indexValueAtIndex:(NSUInteger)targetIndex {
    NSUInteger indexValue = [self firstIndex];
    for (NSUInteger i = 0; i < targetIndex; i++){
        indexValue = [self indexGreaterThanIndex:i];
    }
    return indexValue;
}

- (NSUInteger)ptl_indexOfIndexValue:(NSUInteger)indexValue {
    if (![self containsIndex:indexValue]) {
        return NSNotFound;
    }

    __block NSUInteger indexCounter = 0;
    [self enumerateRangesUsingBlock:^(NSRange range, BOOL *stop) {
        if (indexValue >= range.location &&
            indexValue < NSMaxRange(range)) {
            // Found the value
            indexCounter += indexValue - range.location;
            *stop = YES;
        } else {
            indexCounter += range.length;
        }
    }];
    return indexCounter;
}

@end
