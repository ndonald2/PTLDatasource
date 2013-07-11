//
//  PTLDatasource.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTLDatasource <NSObject>

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)sectionIndex;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
