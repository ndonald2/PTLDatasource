//
//  PTLFilteredDatasource+TableView.h
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import "PTLFilteredDatasource.h"
#import "PTLDatasource+TableView.h"

@interface PTLFilteredDatasource (TableView)

/**
 * @default YES
 */
@property (nonatomic, assign) BOOL tableViewHideHeadersForEmptySections;

/**
 * @default YES
 */
@property (nonatomic, assign) BOOL tableViewHideFootersForEmptySections;

@end
