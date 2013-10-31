//
//  NSMutableIndexSet+PTLDatasource.h
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import <Foundation/Foundation.h>
#import "NSIndexSet+PTLDatasource.h"

@interface NSMutableIndexSet (PTLDatasource)

- (void)ptl_removeIndexValueAtIndex:(NSUInteger)targetIndex;

@end
