//
//  PTLArrayDatasource+TableView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 8/25/13.
//
//

#import "PTLArrayDatasource+TableView.h"

@implementation PTLArrayDatasource (TableView)

#pragma mark - Properties

// TODO: use associated objects to add properties

#pragma mark - Protocol Methods

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
   NSParameterAssert(indexPath.section == 0);
   NSParameterAssert(indexPath.item < [self numberOfItemsInSection:indexPath.section]);
   return self.tableViewCellIdentifier;
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
   NSParameterAssert(indexPath.section == 0);
   NSParameterAssert(indexPath.item < [self numberOfItemsInSection:indexPath.section]);
   return self.tableViewCellConfigBlock;
}

- (NSString *)tableViewHeaderTitleForSection:(NSInteger)sectionIndex {
   NSParameterAssert(sectionIndex == 0);
   return self.tableViewHeaderTitle;
}

- (NSString *)tableViewFooterTitleForSection:(NSInteger)sectionIndex {
   NSParameterAssert(sectionIndex == 0);
   return self.tableViewFooterTitle;
}

@end
