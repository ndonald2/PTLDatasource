//
//  NSArray+PTLDatasource.h
//  PTLDatasource
//
//  Created by Brian Partridge on 12/23/13.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (PTLDatasource)

- (NSArray *)deepCopy;
- (NSMutableArray *)mutableDeepCopy;

@end
