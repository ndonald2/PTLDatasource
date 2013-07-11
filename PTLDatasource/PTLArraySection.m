//
//  PTLArraySection.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree labs. All rights reserved.
//

#import "PTLArraySection.h"

@interface PTLArraySection ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation PTLArraySection

- (id)initWithItems:(NSArray *)items {
	self = [super init];
	if (self) {
	    _items = items;
	}

	return self;
}

#pragma mark - PTLDatasourceSection

- (NSInteger)numberOfItems {
    return self.items.count;
}

- (id)itemAtIndex:(NSInteger)index {
    return [self.items objectAtIndex:index];
}

@end
