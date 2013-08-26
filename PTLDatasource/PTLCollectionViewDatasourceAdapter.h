//
//  PTLCollectionViewDatasourceAdapter.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasource+CollectionView.h"
#import "PTLDatasourceContainer.h"

@interface PTLCollectionViewDatasourceAdapter : PTLDatasource <UICollectionViewDataSource, PTLDatasourceContainer>

- (id)initWithDatasource:(id<PTLCollectionViewDatasource>)datasource;

@end
