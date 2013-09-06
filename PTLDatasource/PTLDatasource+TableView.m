//
//  PTLDatasource+TableView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 8/30/13.
//
//

#import "PTLDatasource+TableView.h"
#import <objc/runtime.h>

static NSString * const kPTLTableViewDatasourceCellIdentifier = @"kPTLTableViewDatasourceCellIdentifier";
static NSString * const kPTLTableViewDatasourceCellConfigBlock = @"kPTLTableViewDatasourceCellConfigBlock";
static NSString * const kPTLTableViewDatasourceHeaderIdentifier = @"kPTLTableViewDatasourceHeaderIdentifier";
static NSString * const kPTLTableViewDatasourceFooterIdentifier = @"kPTLTableViewDatasourceFooterIdentifier";

@implementation PTLDatasource (TableView)

#pragma mark - Properties

- (void)setTableViewCellIdentifier:(NSString *)tableViewCellIdentifier {
   objc_setAssociatedObject(self, (__bridge const void *)(kPTLTableViewDatasourceCellIdentifier), tableViewCellIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)tableViewCellIdentifier {
   return objc_getAssociatedObject(self, (__bridge const void *)(kPTLTableViewDatasourceCellIdentifier));
}

- (void)setTableViewCellConfigBlock:(PTLTableViewCellConfigBlock)tableViewCellConfigBlock {
   objc_setAssociatedObject(self, (__bridge const void *)(kPTLTableViewDatasourceCellConfigBlock), tableViewCellConfigBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlock {
   return objc_getAssociatedObject(self, (__bridge const void *)(kPTLTableViewDatasourceCellConfigBlock));
}

- (void)setTableViewHeaderTitle:(NSString *)tableViewHeaderTitle {
   objc_setAssociatedObject(self, (__bridge const void *)(kPTLTableViewDatasourceHeaderIdentifier), tableViewHeaderTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)tableViewHeaderTitle {
   return objc_getAssociatedObject(self, (__bridge const void *)(kPTLTableViewDatasourceHeaderIdentifier));
}

- (void)setTableViewFooterTitle:(NSString *)tableViewFooterTitle {
   objc_setAssociatedObject(self, (__bridge const void *)(kPTLTableViewDatasourceFooterIdentifier), tableViewFooterTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)tableViewFooterTitle {
   return objc_getAssociatedObject(self, (__bridge const void *)(kPTLTableViewDatasourceFooterIdentifier));
}

#pragma mark - Protocol Methods

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
   NSParameterAssert(indexPath.section < [self numberOfSections]);
   NSParameterAssert(indexPath.item < [self numberOfItemsInSection:indexPath.section]);
   return self.tableViewCellIdentifier;
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
   NSParameterAssert(indexPath.section < [self numberOfSections]);
   NSParameterAssert(indexPath.item < [self numberOfItemsInSection:indexPath.section]);
   return self.tableViewCellConfigBlock;
}

- (NSString *)tableViewHeaderTitleForSection:(NSInteger)sectionIndex {
   NSParameterAssert(sectionIndex < [self numberOfSections]);
   return self.tableViewHeaderTitle;
}

- (NSString *)tableViewFooterTitleForSection:(NSInteger)sectionIndex {
   NSParameterAssert(sectionIndex < [self numberOfSections]);
   return self.tableViewFooterTitle;
}

#pragma mark - UITableViewDatasource Required Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [self numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self tableViewCellIdentifierForIndexPath:indexPath]
                                                           forIndexPath:indexPath];
   PTLTableViewCellConfigBlock block = [self tableViewCellConfigBlockForIndexPath:indexPath];
   if (block != nil) {
      block(tableView, cell, [self itemAtIndexPath:indexPath], indexPath);
   }
   return cell;
}

#pragma mark - UITableViewDatasource Optional Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return [self numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
   return [self tableViewHeaderTitleForSection:sectionIndex];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex {
   return [self tableViewFooterTitleForSection:sectionIndex];
}

@end
