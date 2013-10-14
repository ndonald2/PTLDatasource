//
//  PTLColorCollectionViewController.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLColorCollectionViewController.h"
#import "UIKit+PTLDatasource.h"

static NSString * const kColorCell = @"ColorCell";
static NSString * const kColorHeader = @"ColorHeader";

@interface PTLColorCollectionViewController ()

@property (nonatomic, strong) PTLDatasource *datasource;

@end

@implementation PTLColorCollectionViewController

+ (UICollectionViewFlowLayout *)defaultLayout {
   UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
   layout.headerReferenceSize = CGSizeMake(30, 30);
   return layout;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.title = @"Colors";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kColorCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kColorHeader];

    self.datasource = [[PTLCompositeDatasource alloc] initWithWithDatasources:@[[self colorDatasource],
                                                                                [self colorDatasource],
                                                                                [self colorDatasource],
                                                                                [self colorDatasource]]];
    self.collectionView.dataSource = self.datasource;
}

- (id<PTLDatasource>)colorDatasource {
   NSArray *colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor purpleColor]];
   colors = [colors arrayByAddingObjectsFromArray:colors];
   colors = [colors arrayByAddingObjectsFromArray:colors];
   colors = [colors arrayByAddingObjectsFromArray:colors];

   PTLArrayDatasource *colorDatasource = [[PTLArrayDatasource alloc] initWithItems:colors];
   colorDatasource.collectionViewCellIdentifier = kColorCell;
   colorDatasource.collectionViewCellConfigBlock = ^(UICollectionView *collectionView, UICollectionViewCell *cell, UIColor *color, NSIndexPath *indexPath) {
      cell.backgroundColor = color;
   };

   colorDatasource.collectionViewHeaderIdentifier = kColorHeader;
   colorDatasource.collectionViewHeaderConfigBlock = ^(UICollectionView *collectionView, UICollectionReusableView *view, NSIndexPath *indexPath, NSString *elementKind) {
      view.backgroundColor = [UIColor whiteColor];
   };

   return colorDatasource;
}

@end
