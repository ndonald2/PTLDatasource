//
//  PTLFetchedDatasource+TableView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 8/25/13.
//
//

#import "PTLFetchedDatasource+TableView.h"

@interface PTLFetchedDatasource (Private)

@property (nonatomic, strong) NSFetchedResultsController *controller;

@end

@implementation PTLFetchedDatasource (TableView)

#pragma mark - Protocol Methods

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
   NSParameterAssert(indexPath.self == 0);
   NSParameterAssert(indexPath.item < [self numberOfItemsInSection:indexPath.section]);
   return self.tableViewCellIdentifier;
}

- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
   NSParameterAssert(indexPath.self == 0);
   NSParameterAssert(indexPath.item < [self numberOfItemsInSection:indexPath.section]);
   return self.tableViewCellConfigBlock;
}


- (NSString *)tableViewHeaderTitleForSection:(NSInteger)sectionIndex {
   NSParameterAssert(sectionIndex < [self numberOfSections]);

   NSString *explicitTitle = self.tableViewHeaderTitle;
   if (explicitTitle.length > 0) {
      return (sectionIndex == 0) ? explicitTitle : nil;
   }

   id<NSFetchedResultsSectionInfo> sectionInfo = [self.controller.sections objectAtIndex:sectionIndex];
   return sectionInfo.name;
}

- (NSString *)tableViewFooterTitleForSection:(NSInteger)sectionIndex {
   NSParameterAssert(sectionIndex < [self numberOfSections]);

   NSString *explicitTitle = self.tableViewFooterTitle;
   if (explicitTitle.length > 0 &&
       sectionIndex == 0) {
      return explicitTitle;
   }
   return nil;
}

@end
