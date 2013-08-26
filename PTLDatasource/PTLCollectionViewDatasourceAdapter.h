//
//  PTLCollectionViewDatasourceAdapter.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLCollectionViewDatasource.h"
#import "PTLDatasourceContainer.h"

#import "PTLArrayDatasource+CollectionView.h"
#import "PTLCompositeDatasource+CollectionView.h"
#import "PTLFetchedDatasource+CollectionView.h"
#import "PTLIndexDatasource+CollectionView.h"

@interface PTLCollectionViewDatasourceAdapter : PTLDatasource <UICollectionViewDataSource, PTLDatasourceContainer>

- (id)initWithDatasource:(id<PTLCollectionViewDatasource>)datasource;

@end
