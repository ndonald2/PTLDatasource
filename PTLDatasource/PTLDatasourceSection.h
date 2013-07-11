//
//  PTLDatasourceSection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTLDatasourceSection <NSObject>

- (NSString *)title;
- (NSString *)subtitle;
- (NSInteger)numberOfItems;
- (id)itemAtIndex:(NSInteger)index;

@end
