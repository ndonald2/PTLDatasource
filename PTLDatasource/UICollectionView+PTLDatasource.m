//
//  UICollectionView+PTLDatasource.m
//  PTLDatasource
//
//  Created by Brian Partridge on 12/23/13.
//
//

#import "UICollectionView+PTLDatasource.h"

@implementation UICollectionView (PTLDatasource)

- (void)setPtl_datasource:(id<PTLCollectionViewDatasource>)ptl_datasource {
    self.dataSource = ptl_datasource;
}

- (id<PTLCollectionViewDatasource>)ptl_datasource {
    if ([self.dataSource conformsToProtocol:@protocol(PTLCollectionViewDatasource)]) {
        return (id<PTLCollectionViewDatasource>)self.dataSource;
    }
    return nil;
}

@end
