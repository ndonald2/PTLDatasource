//
//  PTLIndexSection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource.h"
#import "PTLDatasource+TableView.h"
#import "PTLDatasource+CollectionView.h"

@interface PTLIndexDatasource : PTLDatasource <PTLTableViewDatasource, PTLCollectionViewDatasource>

- (id)initWithIndecies:(NSIndexSet *)indecies;

@end
