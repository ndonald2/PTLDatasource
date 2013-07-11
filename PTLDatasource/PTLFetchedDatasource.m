//
//  PTLFetchedSection.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLFetchedDatasource.h"

@interface PTLFetchedDatasource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *controller;

@end

@implementation PTLFetchedDatasource

- (id)initWithFetchedResults:(NSFetchedResultsController *)controller monitorChanges:(BOOL)monitorChanges {
    self = [super init];
    if (self) {
        _controller = controller;
        if (monitorChanges) {
            controller.delegate = self;
        }
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

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self notifyObserversOfChangesBeginning];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self notifyObserversOfSectionChange:PTLChangeTypeAdd
                                    sectionIndex:sectionIndex];
            break;
        case NSFetchedResultsChangeDelete:
            [self notifyObserversOfSectionChange:PTLChangeTypeRemove
                                    sectionIndex:sectionIndex];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self notifyObserversOfChange:PTLChangeTypeAdd
                          sourceIndexPath:indexPath
                     destinationIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [self notifyObserversOfChange:PTLChangeTypeRemove
                          sourceIndexPath:indexPath
                     destinationIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            [self notifyObserversOfChange:PTLChangeTypeUpdate
                          sourceIndexPath:indexPath
                     destinationIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self notifyObserversOfChange:PTLChangeTypeMove
                          sourceIndexPath:indexPath
                     destinationIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self notifyObserversOfChangesEnding];
}

@end
