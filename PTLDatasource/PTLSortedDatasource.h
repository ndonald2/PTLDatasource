//
//  PTLSortedDatasource.h
//  PTLDatasource
//
//  Created by Brian Partridge on 12/26/13.
//
//

#import "PTLDatasource.h"

@interface PTLSortedDatasource : PTLDatasource

@property (nonatomic, assign) NSArray *sortDescriptors;

- (instancetype)initWithDatasource:(id<PTLDatasource>)datasource sortDescriptor:(NSSortDescriptor *)sortDescriptor;
- (instancetype)initWithDatasource:(id<PTLDatasource>)datasource sortDescriptors:(NSArray *)sortDescriptors;

@end
