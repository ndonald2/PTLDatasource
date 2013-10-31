//
//  NSArray+PTLDatasource.m
//  PTLDatasource
//
//  Created by Brian Partridge on 12/23/13.
//
//

#import "NSArray+PTLDatasource.h"

@implementation NSArray (PTLDatasource)

- (NSArray *)deepCopy {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for (id item in self) {
        id copy = item;
        if ([item respondsToSelector:@selector(immutableDeepCopy)]) {
            copy = [item deepCopy];
        } else if ([item respondsToSelector:@selector(copy)]) {
            copy = [item copy];
        }
        [result addObject:copy];
    }
    return [result copy];
}

- (NSMutableArray *)mutableDeepCopy {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    for (id item in self) {
        id mutableCopy = item;
        if ([item respondsToSelector:@selector(mutableDeepCopy)]) {
            mutableCopy = [item mutableDeepCopy];
        } else if ([item respondsToSelector:@selector(mutableCopy)]) {
            mutableCopy = [item mutableCopy];
        }
        [result addObject:mutableCopy];
    }
    return result;
}

@end
