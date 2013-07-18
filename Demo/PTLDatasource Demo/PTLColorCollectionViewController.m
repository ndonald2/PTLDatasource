//
//  PTLColorCollectionViewController.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLColorCollectionViewController.h"
#import "PTLCollectionViewDatasourceAdapter.h"
#import "PTLArrayDatasource.h"

@interface PTLColorCollectionViewController ()

@property (nonatomic, strong) PTLCollectionViewDatasourceAdapter *datasource;

@end

@implementation PTLColorCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.title = @"Colors";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *cellId = @"cell";
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];

    NSArray *colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor purpleColor]];
    colors = [colors arrayByAddingObjectsFromArray:colors];
    colors = [colors arrayByAddingObjectsFromArray:colors];
    colors = [colors arrayByAddingObjectsFromArray:colors];
    colors = [colors arrayByAddingObjectsFromArray:colors];

    PTLArrayDatasource *colorDatasource = [[PTLArrayDatasource alloc] initWithItems:colors];
    colorDatasource.collectionViewCellIdentifier = cellId;
    colorDatasource.collectionViewCellConfigBlock = ^(UICollectionView *collectionView, UICollectionViewCell *cell, UIColor *color, NSIndexPath *indexPath) {
        cell.backgroundColor = color;
    };
    self.datasource = [[PTLCollectionViewDatasourceAdapter alloc] initWithDatasource:colorDatasource];
    self.collectionView.dataSource = self.datasource;
}

@end
