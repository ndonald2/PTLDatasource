//
//  PTLMutableIndexPathMapping.h
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import "PTLIndexPathMapping.h"

@interface PTLMutableIndexPathMapping : PTLIndexPathMapping

- (NSUInteger)addSection:(NSUInteger)sectionIndex toDatasource:(id<PTLDatasource>)mappedDatasource;
- (NSIndexPath *)addItemAtIndexPath:(NSIndexPath *)indexPath toDatasource:(id<PTLDatasource>)mappedDatasource;

- (NSUInteger)removeSection:(NSUInteger)sectionIndex fromDatasource:(id<PTLDatasource>)mappedDatasource;
- (NSIndexPath *)removeItemAtIndexPath:(NSIndexPath *)indexPath fromDatasource:(id<PTLDatasource>)mappedDatasource;

@end
