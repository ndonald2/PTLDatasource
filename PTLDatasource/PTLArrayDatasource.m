//
//  PTLArraySection.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLArrayDatasource.h"

@interface PTLArrayDatasource ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation PTLArrayDatasource

- (id)initWithItems:(NSArray *)items {
	self = [super init];
	if (self) {
	    _items = items;
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
    return self.items.count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.items objectAtIndex:indexPath.item];
}

@end