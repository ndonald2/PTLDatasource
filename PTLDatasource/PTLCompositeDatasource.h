//
//  PTLCompositeDatasource.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Brian Partridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLViewDatasource.h"

@interface PTLCompositeDatasource : NSObject <PTLViewDatasource>

- (id)initWithWithDatasources:(NSArray *)datasources;

@end
