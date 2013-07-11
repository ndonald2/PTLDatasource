//
//  PTLTableViewDatasource.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLTableViewDatasource.h"
#import "PTLTableViewDatasourceSection.h"

@interface PTLTableViewDatasource ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation PTLTableViewDatasource

- (id)initWithWithSections:(NSArray *)sections {
	self = [super init];
	if (self) {
	    _sections = sections;
	}

	return self;
}

#pragma mark - PTLDatasource

- (NSInteger)numberOfSections {
    return self.sections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    id<PTLDatasourceSection> section = [self.sections objectAtIndex:sectionIndex];
    return section.numberOfItems;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    id<PTLDatasourceSection> section = [self.sections objectAtIndex:indexPath.section];
    return [section itemAtIndex:indexPath.row];
}

#pragma mark - Required Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<PTLTableViewDatasourceSection> section = [self.sections objectAtIndex:indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:section.tableViewCellIdentifier forIndexPath:indexPath];
    if (section.tableViewCellConfigBlock != nil) {
        section.tableViewCellConfigBlock(tableView, cell, [self itemAtIndexPath:indexPath], indexPath);
    }
    return cell;
}

#pragma mark - Optional Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
    id<PTLDatasourceSection> section = [self.sections objectAtIndex:sectionIndex];
    return section.title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex {
    id<PTLDatasourceSection> section = [self.sections objectAtIndex:sectionIndex];
    return section.subtitle;
}

@end
