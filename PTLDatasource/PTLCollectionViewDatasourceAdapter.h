//
//  PTLCollectionViewDatasourceAdapter.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasource+CollectionView.h"

@interface PTLCollectionViewDatasourceAdapter : PTLDatasource <PTLCollectionViewDatasource, UICollectionViewDataSource, PTLDatasourceObserver, PTLDatasourceContainer>

- (id)initWithDatasource:(id<PTLCollectionViewDatasource>)datasource;

@end
