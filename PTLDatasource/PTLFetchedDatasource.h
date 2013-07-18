//
//  PTLFetchedSection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#ifdef _COREDATADEFINES_H

#import "PTLDatasource.h"
#import "PTLDatasource+TableView.h"
#import "PTLDatasource+CollectionView.h"
#import <CoreData/CoreData.h>

@interface PTLFetchedDatasource : PTLDatasource <PTLTableViewDatasource, PTLCollectionViewDatasource>

- (id)initWithFetchedResults:(NSFetchedResultsController *)controller trackChanges:(BOOL)trackChanges;

@end

#else

#warning CoreData not found, PTLFetchedDatasource will be unavailable.

#endif
