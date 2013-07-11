//
//  PTLArraySection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLTableViewDatasourceSection.h"

@interface PTLArraySection : NSObject <PTLTableViewDatasourceSection>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) PTLTableViewCellConfigBlock cellConfigBlock;

- (id)initWithItems:(NSArray *)items;

@end
