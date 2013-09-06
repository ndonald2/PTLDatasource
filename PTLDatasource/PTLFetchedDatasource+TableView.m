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

- (NSString *)tableViewHeaderTitleForSection:(NSInteger)sectionIndex {
   NSParameterAssert(sectionIndex < [self numberOfSections]);

   NSString *explicitTitle = [super tableViewHeaderTitleForSection:sectionIndex];
   if (explicitTitle.length > 0) {
      return (sectionIndex == 0) ? explicitTitle : nil;
   }

   id<NSFetchedResultsSectionInfo> sectionInfo = [self.controller.sections objectAtIndex:sectionIndex];
   return sectionInfo.name;
}

- (NSString *)tableViewFooterTitleForSection:(NSInteger)sectionIndex {
   NSParameterAssert(sectionIndex < [self numberOfSections]);

   NSString *explicitTitle = [super tableViewFooterTitleForSection:sectionIndex];
   if (explicitTitle.length > 0 &&
       sectionIndex == 0) {
      return explicitTitle;
   }
   return nil;
}

@end
