//
//  PTLDatasource
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTLDatasource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

- (id)initWithWithSections:(NSArray *)sections;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
