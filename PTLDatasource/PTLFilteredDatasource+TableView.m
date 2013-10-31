//
//  PTLFilteredDatasource+TableView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import "PTLFilteredDatasource+TableView.h"
#import "PTLIndexPathMapping.h"
#import <objc/runtime.h>

static NSString * const kPTLTableViewHideHeadersForEmptySections = @"kPTLTableViewHideHeadersForEmptySections";
static NSString * const kPTLTableViewHideFootersForEmptySections = @"kPTLTableViewHideFootersForEmptySections";

@interface PTLFilteredDatasource (Private_Helpers)

@property (nonatomic, strong) id<PTLDatasource> sourceDatasource;
@property (nonatomic, strong) PTLIndexPathMapping *mapping;

@end

@implementation PTLFilteredDatasource (TableView)

- (void)setTableViewHideHeadersForEmptySections:(BOOL)tableViewHideHeadersForEmptySections {
    objc_setAssociatedObject(self, (__bridge const void *)(kPTLTableViewHideHeadersForEmptySections), @(tableViewHideHeadersForEmptySections), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)tableViewHideHeadersForEmptySections {
    id associtatedObject = objc_getAssociatedObject(self, (__bridge const void *)(kPTLTableViewHideHeadersForEmptySections));
    if (associtatedObject == nil) {
        return YES;
    }
    return [associtatedObject boolValue];
}

- (void)setTableViewHideFootersForEmptySections:(BOOL)tableViewHideFootersForEmptySections {
    objc_setAssociatedObject(self, (__bridge const void *)(kPTLTableViewHideFootersForEmptySections), @(tableViewHideFootersForEmptySections), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)tableViewHideFootersForEmptySections {
    id associtatedObject = objc_getAssociatedObject(self, (__bridge const void *)(kPTLTableViewHideFootersForEmptySections));
    if (associtatedObject == nil) {
        return YES;
    }
    return [associtatedObject boolValue];
}

#pragma mark - Protocol Methods

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    NSString *result = nil;
    if ([self.sourceDatasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
        [self.sourceDatasource respondsToSelector:@selector(tableViewCellIdentifierForIndexPath:)]) {
        id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)self.sourceDatasource;
        NSIndexPath *resolvedIndexPath = [self.mapping datasourceIndexPathForIndexPath:indexPath];
        result = [tableViewDatasource tableViewCellIdentifierForIndexPath:resolvedIndexPath];
    }
    return (result) ?: self.tableViewCellIdentifier;
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    PTLTableViewCellConfigBlock result = nil;
    if ([self.sourceDatasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
        [self.sourceDatasource respondsToSelector:@selector(tableViewCellConfigBlockForIndexPath:)]) {
        id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)self.sourceDatasource;
        NSIndexPath *resolvedIndexPath = [self.mapping datasourceIndexPathForIndexPath:indexPath];
        result = [tableViewDatasource tableViewCellConfigBlockForIndexPath:resolvedIndexPath];
    }
    return (result) ?: self.tableViewCellConfigBlock;
}

- (NSString *)tableViewHeaderTitleForSection:(NSInteger)sectionIndex {
    NSString *result = nil;
    if ([self.sourceDatasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
        [self.sourceDatasource respondsToSelector:@selector(tableViewHeaderTitleForSection:)]) {
        id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)self.sourceDatasource;
        result = [tableViewDatasource tableViewHeaderTitleForSection:sectionIndex];
    }
    return (result) ?: [super tableViewHeaderTitleForSection:sectionIndex];
}

- (NSString *)tableViewFooterTitleForSection:(NSInteger)sectionIndex {
    NSString *result = nil;
    if ([self.sourceDatasource conformsToProtocol:@protocol(PTLTableViewDatasource)] &&
        [self.sourceDatasource respondsToSelector:@selector(tableViewFooterTitleForSection:)]) {
        id<PTLTableViewDatasource> tableViewDatasource = (id<PTLTableViewDatasource>)self.sourceDatasource;
        result = [tableViewDatasource tableViewFooterTitleForSection:sectionIndex];
    }
    return (result) ?: [super tableViewFooterTitleForSection:sectionIndex];
}

#pragma mark - UITableViewDatasource Optional Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    return (self.tableViewHideHeadersForEmptySections &&
            [self numberOfItemsInSection:sectionIndex] == 0) ? nil : [self tableViewHeaderTitleForSection:sectionIndex];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex {
    return (self.tableViewHideFootersForEmptySections &&
            [self numberOfItemsInSection:sectionIndex] == 0) ? nil : [self tableViewFooterTitleForSection:sectionIndex];
}

@end
