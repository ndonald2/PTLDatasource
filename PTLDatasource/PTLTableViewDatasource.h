//
//  PTLTableViewDatasource.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasource.h"

@interface PTLTableViewDatasource : NSObject <PTLDatasource, UITableViewDataSource>

- (id)initWithWithSections:(NSArray *)sections;

@end
