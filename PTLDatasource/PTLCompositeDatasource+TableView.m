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
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
       [datasource respondsToSelector:@selector(tableViewCellIdentifierForIndexPath:)]) {
      id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      return [tableViewDatasource tableViewCellIdentifierForIndexPath:resolvedIndexPath];
   }
   return nil;
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:indexPath.section];
   if ([datasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
       [datasource respondsToSelector:@selector(tableViewCellConfigBlockForIndexPath:)]) {
      id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)datasource;
      NSIndexPath *resolvedIndexPath = [self resolvedChildDatasourceIndexPathForIndexPath:indexPath];
      return [tableViewDatasource tableViewCellConfigBlockForIndexPath:resolvedIndexPath];
   }
   return nil;
}

- (NSString *)tableViewHeaderTitleForSection:(NSInteger)sectionIndex {
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:sectionIndex];
   if ([datasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
       [datasource respondsToSelector:@selector(tableViewHeaderTitleForSection:)]) {
      id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)datasource;
      NSInteger resolvedSectionIndex = [self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex];
      return [tableViewDatasource tableViewHeaderTitleForSection:resolvedSectionIndex];
   }
   return nil;
}

- (NSString *)tableViewFooterTitleForSection:(NSInteger)sectionIndex {
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:sectionIndex];
   if ([datasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
       [datasource respondsToSelector:@selector(tableViewFooterTitleForSection:)]) {
      id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)datasource;
      NSInteger resolvedSectionIndex = [self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex];
      return [tableViewDatasource tableViewFooterTitleForSection:resolvedSectionIndex];
   }
   return nil;
}

@end
