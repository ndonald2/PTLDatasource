//
//  PTLDatasource+TableView.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource+TableView.h"
#import <objc/runtime.h>

@interface PTLDatasource (TableView_Private)

@property (nonatomic, readonly, strong) NSMutableDictionary *sectionToTitle;
@property (nonatomic, readonly, strong) NSMutableDictionary *sectionToSubtitle;
@property (nonatomic, readonly, strong) NSMutableDictionary *indexPathToTableViewCellIdentifier;
@property (nonatomic, readonly, strong) NSMutableDictionary *indexPathToTableViewCellConfigBlock;

@end

@implementation PTLDatasource (TableView)

#pragma mark - Properties

@dynamic tableViewSectionHeaderTitle;

- (NSString *)tableViewSectionHeaderTitle {
    return objc_getAssociatedObject(self, @"title");
}

- (void)setTableViewSectionHeaderTitle:(NSString *)title {
    objc_setAssociatedObject(self, @"title", title, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@dynamic tableViewSectionFooterTitle;

- (NSString *)tableViewSectionFooterTitle {
    return objc_getAssociatedObject(self, @"subtitle");
}

- (void)setSubitle:(NSString *)subtitle {
    objc_setAssociatedObject(self, @"subtitle", subtitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@dynamic tableViewCellIdentifier;

- (NSString *)tableViewCellIdentifier {
    return objc_getAssociatedObject(self, @"tableViewCellIdentifier");
}

- (void)setTableViewCellIdentifier:(NSString *)tableViewCellIdentifier {
    objc_setAssociatedObject(self, @"tableViewCellIdentifier", tableViewCellIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@dynamic tableViewCellConfigBlock;

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlock {
    return objc_getAssociatedObject(self, @"tableViewCellConfigBlock");
}

- (void)setTableViewCellConfigBlock:(PTLTableViewCellConfigBlock)tableViewCellConfigBlock {
    objc_setAssociatedObject(self, @"tableViewCellConfigBlock", tableViewCellConfigBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Setters

- (void)setTableViewSectionHeaderTitle:(NSString *)title forSection:(NSInteger)sectionIndex {
    [self.sectionToTitle setObject:title forKey:@(sectionIndex)];
}

- (void)setTableViewSectionFooterTitle:(NSString *)title forSection:(NSInteger)sectionIndex {
    [self.sectionToSubtitle setObject:title forKey:@(sectionIndex)];
}

- (void)setTableViewCellIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    [self.indexPathToTableViewCellIdentifier setObject:identifier forKey:indexPath];
}

- (void)setTableViewCellConfigBlock:(PTLTableViewCellConfigBlock)block forIndexPath:(NSIndexPath *)indexPath {
    [self.indexPathToTableViewCellConfigBlock setObject:[block copy] forKey:indexPath];
}

#pragma mark - Getters

- (NSString *)tableViewSectionHeaderTitleForSection:(NSInteger)sectionIndex {
    NSString *title = [self.sectionToTitle objectForKey:@(sectionIndex)];
    if (title == nil) {
        title = self.tableViewSectionHeaderTitle;
    }
    return title;
}

- (NSString *)tableViewSectionFooterTitleForSection:(NSInteger)sectionIndex {
    NSString *subtitle = [self.sectionToSubtitle objectForKey:@(sectionIndex)];
    if (subtitle == nil) {
        subtitle = self.tableViewSectionFooterTitle;
    }
    return subtitle;
}

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [self.indexPathToTableViewCellIdentifier objectForKey:indexPath];
    if (identifier == nil) {
        identifier = self.tableViewCellIdentifier;
    }
    return identifier;
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    PTLTableViewCellConfigBlock block = [self.indexPathToTableViewCellConfigBlock objectForKey:indexPath];
    if (block == nil) {
        block = self.tableViewCellConfigBlock;
    }

    return block;
}

@end

@implementation PTLDatasource (TableView_Private)

#pragma mark - Private Properties

@dynamic sectionToTitle;

- (NSMutableDictionary *)sectionToTitle {
    NSMutableDictionary *result = objc_getAssociatedObject(self, @"sectionToTitle");
    if (result == nil) {
        objc_setAssociatedObject(self, @"sectionToTitle", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

@dynamic sectionToSubtitle;

- (NSMutableDictionary *)sectionToSubtitle {
    NSMutableDictionary *result = objc_getAssociatedObject(self, @"sectionToSubtitle");
    if (result == nil) {
        objc_setAssociatedObject(self, @"sectionToSubtitle", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

@dynamic indexPathToTableViewCellIdentifier;

- (NSMutableDictionary *)indexPathToTableViewCellIdentifier {
    NSMutableDictionary *result = objc_getAssociatedObject(self, @"indexPathToTableViewCellIdentifier");
    if (result == nil) {
        objc_setAssociatedObject(self, @"indexPathToTableViewCellIdentifier", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

@dynamic indexPathToTableViewCellConfigBlock;

- (NSMutableDictionary *)indexPathToTableViewCellConfigBlock {
    NSMutableDictionary *result = objc_getAssociatedObject(self, @"indexPathToTableViewCellConfigBlock");
    if (result == nil) {
        objc_setAssociatedObject(self, @"indexPathToTableViewCellConfigBlock", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

@end
