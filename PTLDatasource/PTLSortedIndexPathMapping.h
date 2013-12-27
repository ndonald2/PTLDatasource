//
//  PTLSortedIndexPathMapping.h
//  PTLDatasource
//
//  Created by Brian Partridge on 12/26/13.
//
//

#import <Foundation/Foundation.h>
#import "PTLDatasource.h"

@interface PTLSortedIndexPathMapping : NSObject <NSMutableCopying>

/**
 * An array of arrays.
 * The position in the array corresponds to the datasource's section number.
 * The position in the inner array represents the sorted index of item in the datasource.
 */
@property (nonatomic, readonly, strong) NSArray *sortedItemsBySection;

@property (nonatomic, readonly, strong) NSArray *sortDescriptors;

@property (nonatomic, readonly, strong) id<PTLDatasource> datasource;

- (instancetype)initWithMapping:(PTLSortedIndexPathMapping *)mapping;
- (instancetype)initWithSortDescriptors:(NSArray *)sortDescriptors datasource:(id<PTLDatasource>)datasource;

- (NSIndexPath *)indexPathForDatasourceIndexPath:(NSIndexPath *)datasourceIndexPath;
- (NSIndexPath *)datasourceIndexPathForIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - Helpers

NS_INLINE NSComparator PTLComparitorMake(NSArray *sortDescriptors) {
    return ^NSComparisonResult(id obj1, id obj2) {
        for (NSSortDescriptor *descriptor in sortDescriptors) {
            NSComparisonResult result = [descriptor compareObject:obj1 toObject:obj2];
            if (result != NSOrderedSame) {
                return result;
            }
        }
        return NSOrderedSame;
    };
}
