//
//  PTLCompositeDatasource+TableView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 8/25/13.
//
//

#import "PTLCompositeDatasource+TableView.h"

@interface PTLCompositeDatasource (Private_Helpers)

- (NSInteger)resolvedChildDatasourceSectionIndexForSectionIndex:(NSInteger)sectionIndex;
- (NSIndexPath *)resolvedChildDatasourceIndexPathForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PTLCompositeDatasource (TableView)

#pragma mark - Protocol Methods

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
   NSString *result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
       [datasource respondsToSelector:@selector(tableViewCellIdentifierForIndexPath:)]) {
      id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      result = [tableViewDatasource tableViewCellIdentifierForIndexPath:resolvedIndexPath];
   }
   return (result) ?: self.tableViewCellIdentifier;
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
   PTLTableViewCellConfigBlock result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
       [datasource respondsToSelector:@selector(tableViewCellConfigBlockForIndexPath:)]) {
      id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      result = [tableViewDatasource tableViewCellConfigBlockForIndexPath:resolvedIndexPath];
   }
   return (result) ?: self.tableViewCellConfigBlock;
}

- (NSString *)tableViewHeaderTitleForSection:(NSInteger)sectionIndex {
   NSString *result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:sectionIndex];
   if ([datasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
       [datasource respondsToSelector:@selector(tableViewHeaderTitleForSection:)]) {
      id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)datasource;
      NSInteger resolvedSectionIndex = [self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex];
      result = [tableViewDatasource tableViewHeaderTitleForSection:resolvedSectionIndex];
   }
   return (result) ?: [super tableViewHeaderTitleForSection:sectionIndex];
}

- (NSString *)tableViewFooterTitleForSection:(NSInteger)sectionIndex {
   NSString *result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:sectionIndex];
   if ([datasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
       [datasource respondsToSelector:@selector(tableViewFooterTitleForSection:)]) {
      id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)datasource;
      NSInteger resolvedSectionIndex = [self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex];
      result = [tableViewDatasource tableViewFooterTitleForSection:resolvedSectionIndex];
   }
   return (result) ?: [super tableViewFooterTitleForSection:sectionIndex];
}

@end
