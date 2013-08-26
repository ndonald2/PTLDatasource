//
//  PTLArrayDatasource+TableView.h
//  PTLDatasource
//
//  Created by Brian Partridge on 8/25/13.
//
//

#import "PTLArrayDatasource.h"
#import "PTLTableViewDatasource.h"

@interface PTLArrayDatasource (TableView) <PTLTableViewDatasource>

@property (nonatomic, copy) NSString *tableViewHeaderTitle;
@property (nonatomic, copy) NSString *tableViewFooterTitle;
@property (nonatomic, copy) NSString *tableViewCellIdentifier;
@property (nonatomic, copy) PTLTableViewCellConfigBlock tableViewCellConfigBlock;

@end
