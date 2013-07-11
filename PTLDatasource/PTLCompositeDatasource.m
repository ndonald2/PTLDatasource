//
//  PTLCompositeDatasource.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Brian Partridge. All rights reserved.
//

#import "PTLCompositeDatasource.h"

@interface PTLCompositeDatasource ()

@property (nonatomic, strong) NSArray *datasources;
@property (nonatomic, strong) NSDictionary *datasourceToSectionRange;

@end

@implementation PTLCompositeDatasource

- (id)initWithWithDatasources:(NSArray *)datasources {
	self = [super init];
	if (self) {
	    _datasources = datasources;
        [self reloadSectionsFromDatasources];
	}

	return self;
}

- (void)reloadSectionsFromDatasources {
    NSMutableDictionary *datasourceToSectionRange = [NSMutableDictionary dictionary];

    NSInteger offset = 0;
    for (id<PTLDatasource> datasource in self.datasources) {
        NSRange sectionRange = NSMakeRange(offset, [datasource numberOfSections]);
        [datasourceToSectionRange setObject:[NSValue valueWithRange:sectionRange] forKey:datasource];
        offset = sectionRange.location + sectionRange.length;
    }

    self.datasourceToSectionRange = [datasourceToSectionRange copy];
}

- (id<PTLDatasource>)datasourceForSectionIndex:(NSInteger)sectionIndex {
    for (id<PTLDatasource> datasource in self.datasources) {
        NSRange sectionRange = [[self.datasourceToSectionRange objectForKey:datasource] rangeValue];
        if (sectionRange.location <= sectionIndex &&
            sectionIndex < sectionRange.location + sectionRange.length) {
            return datasource;
        }
    }
    return nil;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - PTLDatasource

- (NSInteger)numberOfSections {
    NSInteger count = 0;
    for (id<PTLDatasource> datasource in self.datasources) {
        count += [datasource numberOfSections];
    }
    return count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex {
    id<PTLDatasource> datasource = [self datasourceForSectionIndex:sectionIndex];
    NSRange sectionRange = [[self.datasourceToSectionRange objectForKey:datasource] rangeValue];
    NSInteger translatedSectionIndex = sectionIndex - sectionRange.location;
    return [datasource numberOfItemsInSection:translatedSectionIndex];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    id<PTLDatasource> datasource = [self datasourceForSectionIndex:indexPath.section];
    NSRange sectionRange = [[self.datasourceToSectionRange objectForKey:datasource] rangeValue];
    NSInteger translatedSectionIndex = indexPath.section - sectionRange.location;
    NSIndexPath *translatedIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:translatedSectionIndex];
    return [datasource itemAtIndexPath:translatedIndexPath];
}

#pragma mark - PTLTableViewDatasource

- (NSString *)titleForSection:(NSInteger)sectionIndex {
    id datasource = [self datasourceForSectionIndex:sectionIndex];
    return [datasource titleForSection:sectionIndex];
}

- (NSString *)subtitleForSection:(NSInteger)sectionIndex {
    id datasource = [self datasourceForSectionIndex:sectionIndex];
    return [datasource subtitleForSection:sectionIndex];
}

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self datasourceForSectionIndex:indexPath.section];
    return [datasource tableViewCellIdentifierForIndexPath:indexPath];
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self datasourceForSectionIndex:indexPath.section];
    return [datasource tableViewCellConfigBlockForIndexPath:indexPath];
}

#pragma mark - PTLCollectionViewDatasource

- (NSString *)collectionViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self datasourceForSectionIndex:indexPath.section];
    return [datasource collectionViewCellIdentifierForIndexPath:indexPath];
}

- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self datasourceForSectionIndex:indexPath.section];
    return [datasource collectionViewCellConfigBlockForIndexPath:indexPath];
}

- (NSString *)collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self datasourceForSectionIndex:indexPath.section];
    return [datasource collectionViewSupplementaryViewIdentifierForIndexPath:indexPath];
}

- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    id datasource = [self datasourceForSectionIndex:indexPath.section];
    return [datasource collectionViewSupplementaryViewConfigBlockForIndexPath:indexPath];
}

@end
