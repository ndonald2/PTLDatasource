//
//  PTLCompositeDatasource+TableView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 8/25/13.
//
//

#import "PTLCompositeDatasource+TableView.h"
#import "NSObject+PTLSwizzle.h"

@interface PTLCompositeDatasource (Private_Helpers)

- (NSInteger)resolvedChildDatasourceSectionIndexForSectionIndex:(NSInteger)sectionIndex;
- (NSIndexPath *)resolvedChildDatasourceIndexPathForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PTLCompositeDatasource (TableView)

+ (void)load {
   [self ptl_swizzleMethod:@selector(tableViewCellIdentifierForIndexPath:) withMethod:@selector(composite_tableViewCellIdentifierForIndexPath:)];
   [self ptl_swizzleMethod:@selector(tableViewCellConfigBlockForIndexPath:) withMethod:@selector(composite_tableViewCellConfigBlockForIndexPath:)];
   [self ptl_swizzleMethod:@selector(tableViewHeaderTitleForSection:) withMethod:@selector(composite_tableViewHeaderTitleForSection:)];
   [self ptl_swizzleMethod:@selector(tableViewFooterTitleForSection:) withMethod:@selector(composite_tableViewFooterTitleForSection:)];
}

#pragma mark - Protocol Methods

- (NSString *)composite_tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
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

- (PTLTableViewCellConfigBlock)composite_tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
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

- (NSString *)composite_tableViewHeaderTitleForSection:(NSInteger)sectionIndex {
   NSString *result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:sectionIndex];
   if ([datasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
       [datasource respondsToSelector:@selector(tableViewHeaderTitleForSection:)]) {
      id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)datasource;
      NSInteger resolvedSectionIndex = [self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex];
      result = [tableViewDatasource tableViewHeaderTitleForSection:resolvedSectionIndex];
   }
   return (result) ?: [self composite_tableViewHeaderTitleForSection:sectionIndex];
}

- (NSString *)composite_tableViewFooterTitleForSection:(NSInteger)sectionIndex {
   NSString *result = nil;
   id<PTLDatasource> datasource = [self descendantDatasourceContainingSectionIndex:sectionIndex];
   if ([datasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
       [datasource respondsToSelector:@selector(tableViewFooterTitleForSection:)]) {
      id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)datasource;
      NSInteger resolvedSectionIndex = [self resolvedChildDatasourceSectionIndexForSectionIndex:sectionIndex];
      result = [tableViewDatasource tableViewFooterTitleForSection:resolvedSectionIndex];
   }
   return (result) ?: [self composite_tableViewFooterTitleForSection:sectionIndex];
}

@end
