//
//  PTLIndexPathMapping.h
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import <Foundation/Foundation.h>
#import "PTLDatasource.h"
#import "PTLIndexPathMappingDelta.h"

@interface PTLIndexPathMapping : NSObject <NSMutableCopying>

/**
 * An array of NSIndexSets.  
 * The position in the array corresponds to the datasource's section number.
 * The contents of the index set represent the indecies of items in the datasource that passed the filter.
 */
@property (nonatomic, readonly, strong) NSArray *itemIndeciesBySection;

@property (nonatomic, strong) NSPredicate *filter;

+ (BOOL)evaluateFilter:(NSPredicate *)filter onItem:(id)item;

- (instancetype)initWithMapping:(PTLIndexPathMapping *)mapping;
- (instancetype)initWithFilter:(NSPredicate *)filter datasource:(id<PTLDatasource>)datasource;

- (NSIndexPath *)indexPathForDatasourceIndexPath:(NSIndexPath *)datasourceIndexPath;
- (NSIndexPath *)datasourceIndexPathForIndexPath:(NSIndexPath *)indexPath;

- (PTLIndexPathMappingDelta *)deltaToMapping:(PTLIndexPathMapping *)toMapping;
- (PTLIndexPathMappingDelta *)deltaFromMapping:(PTLIndexPathMapping *)fromMapping;

@end
