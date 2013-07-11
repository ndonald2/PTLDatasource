//
//  PTLIndexSection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Brian Partridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLTableViewDatasourceSection.h"

@interface PTLIndexSection : NSObject <PTLTableViewDatasourceSection>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) PTLTableViewCellConfigBlock cellConfigBlock;

- (id)initWithIndecies:(NSIndexSet *)indecies;

@end
