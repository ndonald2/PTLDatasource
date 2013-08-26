//
//  PTLDatasourceContainer.h
//  PTLDatasource
//
//  Created by Brian Partridge on 8/1/13.
//
//

#import "PTLDatasource.h"

/// Adopted by a datasource which aggregates the items of a number of child datasources.
/// The datasource is responsible for handling change observations in its children.
@protocol PTLDatasourceContainer <PTLDatasource, PTLDatasourceObserver>

- (NSInteger)numberOfChildDatasources;
- (id<PTLDatasource>)childDatasourceAtIndex:(NSInteger)datasourceIndex;
- (NSIndexSet *)sectionIndicesForDescendantDatasource:(id<PTLDatasource>)datasource;
- (id<PTLDatasource>)descendantDatasourceContainingSectionIndex:(NSInteger)sectionIndex;

@end
