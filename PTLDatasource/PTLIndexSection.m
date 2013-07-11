//
//  PTLIndexSection.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLIndexSection.h"

@interface NSIndexSet (Indexing)

- (NSUInteger)ptl_indexAtIndex:(NSUInteger)targetIndex;

@end

@implementation NSIndexSet (Indexing)

- (NSUInteger)ptl_indexAtIndex:(NSUInteger)targetIndex {
    NSUInteger index = [self firstIndex];
    for (NSUInteger i = 0; i < targetIndex; i++){
        index = [self indexGreaterThanIndex:i];
    }
    return index;
}

@end

@interface PTLIndexSection ()

@property (nonatomic, strong) NSIndexSet *indecies;

@end

@implementation PTLIndexSection

- (id)initWithIndecies:(NSIndexSet *)indecies {
	self = [super init];
	if (self) {
	    _indecies = indecies;
	}

	return self;
}

#pragma mark - PTLDatasourceSection

- (NSInteger)numberOfItems {
    return self.indecies.count;
}

- (id)itemAtIndex:(NSInteger)index {
    return @([self.indecies ptl_indexAtIndex:index]);
}

@end
