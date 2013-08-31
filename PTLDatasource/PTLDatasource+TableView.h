//
//  PTLDatasource+TableView.h
//  PTLDatasource
//
//  Created by Brian Partridge on 8/30/13.
//
//

#import "PTLDatasource.h"
#import "PTLTableViewDatasource.h"

@interface PTLDatasource (TableView) <PTLTableViewDatasource>

@property (nonatomic, copy) NSString *tableViewHeaderTitle;
@property (nonatomic, copy) NSString *tableViewFooterTitle;
@property (nonatomic, copy) NSString *tableViewCellIdentifier;
@property (nonatomic, copy) PTLTableViewCellConfigBlock tableViewCellConfigBlock;

@end
