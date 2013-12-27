//
//  PTLMutableSortedIndexPathMapping.h
//  PTLDatasource
//
//  Created by Brian Partridge on 12/26/13.
//
//

#import "PTLSortedIndexPathMapping.h"

@interface PTLMutableSortedIndexPathMapping : PTLSortedIndexPathMapping <NSMutableCopying>

- (NSUInteger)addSection:(NSUInteger)sectionIndex toDatasource:(id<PTLDatasource>)mappedDatasource;
- (NSIndexPath *)addItemAtIndexPath:(NSIndexPath *)indexPath toDatasource:(id<PTLDatasource>)mappedDatasource;

- (NSUInteger)removeSection:(NSUInteger)sectionIndex fromDatasource:(id<PTLDatasource>)mappedDatasource;
- (NSIndexPath *)removeItemAtIndexPath:(NSIndexPath *)indexPath fromDatasource:(id<PTLDatasource>)mappedDatasource;

- (NSIndexPath *)updateItemAtIndexPath:(NSIndexPath *)indexPath fromDatasource:(id<PTLDatasource>)mappedDatasource;

@end
