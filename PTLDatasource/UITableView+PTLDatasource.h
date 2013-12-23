//
//  UITableView+PTLDatasource.h
//  PTLDatasource
//
//  Created by Brian Partridge on 12/23/13.
//
//

#import <UIKit/UIKit.h>
#import "PTLDatasource+TableView.h"

@interface UITableView (PTLDatasource)

@property (nonatomic, assign) id <PTLTableViewDatasource> ptl_datasource;

@end
