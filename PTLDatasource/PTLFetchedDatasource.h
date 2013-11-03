//
//  PTLFetchedSection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource.h"
#import <CoreData/CoreData.h>

@interface PTLFetchedDatasource : PTLDatasource

- (id)initWithFetchedResults:(NSFetchedResultsController *)controller trackChanges:(BOOL)trackChanges;

@end
