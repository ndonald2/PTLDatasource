//
//  PTLIndexSection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLTableViewDatasource.h"
#import "PTLCollectionViewDatasource.h"

@interface PTLIndexDatasource : NSObject <PTLTableViewDatasource, PTLCollectionViewDatasource>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *tableViewCellIdentifier;
@property (nonatomic, copy) PTLTableViewCellConfigBlock tableViewCellConfigBlock;

@property (nonatomic, copy) NSString *collectionViewCellIdentifier;
@property (nonatomic, copy) PTLCollectionViewCellConfigBlock collectionViewCellConfigBlock;

- (id)initWithIndecies:(NSIndexSet *)indecies;

@end
