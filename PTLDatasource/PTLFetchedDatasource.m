//
//  PTLFetchedSection.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLFetchedDatasource.h"

#ifdef _COREDATADEFINES_H

@interface PTLFetchedDatasource ()

@property (nonatomic, strong) NSFetchedResultsController *controller;

@end

@implementation PTLFetchedDatasource

- (id)initWithFetchedResults:(NSFetchedResultsController *)controller {
    self = [super init];
    if (self) {
        _controller = controller;
    }

    return self;
}

#pragma mark - PTLDatasource

- (NSInteger)numberOfSections {
    return self.controller.sections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    return ((id<NSFetchedResultsSectionInfo>)[self.controller.sections objectAtIndex:sectionIndex]).numberOfObjects;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.controller objectAtIndexPath:indexPath];
}

@end

#endif
