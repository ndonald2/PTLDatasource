//
//  PTLFetchedDatasource+TableView.h
//  PTLDatasource
//
//  Created by Brian Partridge on 8/25/13.
//
//

#import "PTLFetchedDatasource.h"
#import "PTLTableViewDatasource.h"

@interface PTLFetchedDatasource (TableView) <PTLTableViewDatasource>

@property (nonatomic, copy) NSString *tableViewHeaderTitle;
@property (nonatomic, copy) NSString *tableViewFooterTitle;
@property (nonatomic, copy) NSString *tableViewCellIdentifier;
@property (nonatomic, copy) PTLTableViewCellConfigBlock tableViewCellConfigBlock;

@end
