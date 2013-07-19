//
//  PTLTableViewDatasourceAdapter.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasource+TableView.h"

@interface PTLTableViewDatasourceAdapter : PTLDatasource <PTLTableViewDatasource, UITableViewDataSource, PTLDatasourceObserver, PTLDatasourceContainer>

- (id)initWithDatasource:(id<PTLTableViewDatasource>)datasource;

@end
