//
//  UICollectionView+PTLDatasource.h
//  PTLDatasource
//
//  Created by Brian Partridge on 12/23/13.
//
//

#import <UIKit/UIKit.h>
#import "PTLCollectionViewDatasource.h"

@interface UICollectionView (PTLDatasource)

@property (nonatomic, assign) id <PTLCollectionViewDatasource> ptl_datasource;

@end
