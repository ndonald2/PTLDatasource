//
//  PTLTableViewDatasource.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasource.h"

typedef void(^PTLTableViewCellConfigBlock)(UITableView *tableView, UITableViewCell *cell, id item, NSIndexPath *indexPath);

@protocol PTLTableViewDatasource <PTLDatasource>

- (NSString *)titleForSection:(NSInteger)sectionIndex;
- (NSString *)subtitleForSection:(NSInteger)sectionIndex;

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath;

@end
