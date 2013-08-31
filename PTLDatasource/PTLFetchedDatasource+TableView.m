//
//  PTLFetchedDatasource+TableView.m
//  PTLDatasource
//
//  Created by Brian Partridge on 8/25/13.
//
//

#import "PTLFetchedDatasource+TableView.h"
#import "NSObject+PTLSwizzle.h"

@interface PTLFetchedDatasource (Private)

@property (nonatomic, strong) NSFetchedResultsController *controller;

@end

@implementation PTLFetchedDatasource (TableView)

+ (void)load {
   [self ptl_swizzleMethod:@selector(tableViewHeaderTitleForSection:) withMethod:@selector(fetched_tableViewHeaderTitleForSection:)];
   [self ptl_swizzleMethod:@selector(tableViewFooterTitleForSection:) withMethod:@selector(fetched_tableViewFooterTitleForSection:)];
}

#pragma mark - Protocol Methods

- (NSString *)fetched_tableViewHeaderTitleForSection:(NSInteger)sectionIndex {
   NSParameterAssert(sectionIndex < [self numberOfSections]);

   NSString *explicitTitle = [self fetched_tableViewHeaderTitleForSection:sectionIndex];
   if (explicitTitle.length > 0) {
      return (sectionIndex == 0) ? explicitTitle : nil;
   }

   id<NSFetchedResultsSectionInfo> sectionInfo = [self.controller.sections objectAtIndex:sectionIndex];
   return sectionInfo.name;
}

- (NSString *)fetched_tableViewFooterTitleForSection:(NSInteger)sectionIndex {
   NSParameterAssert(sectionIndex < [self numberOfSections]);

   NSString *explicitTitle = [self fetched_tableViewFooterTitleForSection:sectionIndex];
   if (explicitTitle.length > 0 &&
       sectionIndex == 0) {
      return explicitTitle;
   }
   return nil;
}

@end
