//
//  PTLCompositeDatasource.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLDatasource+TableView.h"
#import "PTLDatasource+CollectionView.h"

@interface PTLCompositeDatasource : PTLDatasource <PTLTableViewDatasource, PTLCollectionViewDatasource, PTLDatasourceObserver, PTLDatasourceContainer>

- (id)initWithWithDatasources:(NSArray *)datasources;

@end
