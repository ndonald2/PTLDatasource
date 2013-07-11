//
//  PTLIndexSection.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLIndexDatasource.h"

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

@interface PTLIndexDatasource ()

@property (nonatomic, strong) NSIndexSet *indecies;

@end

@implementation PTLIndexDatasource

- (id)initWithIndecies:(NSIndexSet *)indecies {
	self = [super init];
	if (self) {
	    _indecies = indecies;
	}

	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - PTLDatasource

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    return self.indecies.count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return @([self.indecies ptl_indexAtIndex:indexPath.item]);
}

@end
