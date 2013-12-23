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
    NSParameterAssert(targetIndex < self.count);
    
    NSUInteger indexValue = [self firstIndex];
    for (NSUInteger i = 0; i < targetIndex; i++){
        indexValue = [self indexGreaterThanIndex:indexValue];
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

- (NSIndexSet *)ptl_intersectionWithIndexSet:(NSIndexSet *)indexSet {
    if (self.firstIndex > indexSet.lastIndex ||
        self.lastIndex < indexSet.firstIndex) {
        return [NSIndexSet indexSet];
    }

    NSMutableIndexSet *results = [NSMutableIndexSet indexSet];
    [self enumerateRangesUsingBlock:^(NSRange outerRange, BOOL *stop) {
        [indexSet enumerateRangesInRange:outerRange options:kNilOptions usingBlock:^(NSRange innerRange, BOOL *stop) {
            [results addIndexesInRange:innerRange];
        }];
    }];
    return [results copy];
}

- (NSIndexSet *)ptl_unionWithIndexSet:(NSIndexSet *)indexSet {
    NSMutableIndexSet *results = [self mutableCopy];
    [indexSet enumerateRangesUsingBlock:^(NSRange range, BOOL *stop) {
        [results addIndexesInRange:range];
    }];
    return [results copy];
}

- (NSIndexSet *)ptl_indeciesNotInIndexSet:(NSIndexSet *)indexSet {
    NSMutableIndexSet *results = [NSMutableIndexSet indexSet];
    [self enumerateRangesUsingBlock:^(NSRange outerRange, BOOL *stop) {
        if ([indexSet containsIndexesInRange:outerRange]) {
            // Pass
        } else {
            // Add the range to the results
            [results addIndexesInRange:outerRange];

            // Remove any indecies that are in the other set
            [indexSet enumerateRangesInRange:outerRange options:kNilOptions usingBlock:^(NSRange innerRange, BOOL *stop) {
                [results removeIndexesInRange:innerRange];
            }];
        }
    }];
    return [results copy];
}

@end
