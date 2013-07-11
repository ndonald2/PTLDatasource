//
//  PTLTableViewDatasourceSection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasourceSection.h"

typedef void(^PTLTableViewCellConfigBlock)(UITableView *tableView, UITableViewCell *cell, id item, NSIndexPath *indexPath);

@protocol PTLTableViewDatasourceSection <PTLDatasourceSection>

- (NSString *)tableViewCellIdentifier;
- (PTLTableViewCellConfigBlock)tableViewCellConfigBlock;

@end
