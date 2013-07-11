//
//  PTLViewDatasource
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLTableViewDatasource.h"
#import "PTLCollectionViewDatasource.h"

@protocol PTLViewDatasource <PTLTableViewDatasource, PTLCollectionViewDatasource>
@end

@interface PTLViewDatasource : NSObject <PTLViewDatasource, UITableViewDataSource, UICollectionViewDataSource>

- (id)initWithDatasource:(id<PTLViewDatasource>)datasource;

@end
