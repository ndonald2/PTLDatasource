//
//  PTLFetchedSection.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLFetchedSection.h"

#ifdef _COREDATADEFINES_H

@interface PTLFetchedSection ()

@property (nonatomic, strong) NSFetchRequest *request;
@property (nonatomic, strong) NSFetchedResultsController *controller;

@end

@implementation PTLFetchedSection

- (id)initWithFetchedResults:(NSFetchedResultsController *)controller {
    self = [super init];
    if (self) {
        _controller = controller;
    }

    return self;
}

#pragma mark - PTLDatasourceSection

- (NSInteger)numberOfItems {
    return ((id<NSFetchedResultsSectionInfo>)[self.controller.sections lastObject]).numberOfObjects;
}

- (id)itemAtIndex:(NSInteger)index {
    return [self.controller objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

@end

#endif
