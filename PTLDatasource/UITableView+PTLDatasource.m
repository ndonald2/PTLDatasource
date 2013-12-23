//
//  UITableView+PTLDatasource.m
//  PTLDatasource
//
//  Created by Brian Partridge on 12/23/13.
//
//

#import "UITableView+PTLDatasource.h"

@implementation UITableView (PTLDatasource)

- (void)setPtl_datasource:(id<PTLTableViewDatasource>)ptl_datasource {
    self.dataSource = ptl_datasource;
}

- (id<PTLTableViewDatasource>)ptl_datasource {
    if ([self.dataSource conformsToProtocol:@protocol(PTLTableViewDatasource)]) {
        return (id<PTLTableViewDatasource>)self.dataSource;
    }
    return nil;
}

@end
