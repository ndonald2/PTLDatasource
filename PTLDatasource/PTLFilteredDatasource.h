//
//  PTLFilteredDatasource.h
//  PTLDatasource
//
//  Created by Brian Partridge on 10/30/13.
//
//

#import "PTLDatasource.h"

@interface PTLFilteredDatasource : PTLDatasource

@property (nonatomic, strong) NSPredicate *filter;

- (instancetype)initWithDatasource:(id<PTLDatasource>)datasource filter:(NSPredicate *)filter;

@end
