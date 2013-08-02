//
//  PTLCompositeDatasource.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLDatasource+Containment.h"

@interface PTLCompositeDatasource : PTLDatasource <PTLDatasourceContainer>

- (id)initWithWithDatasources:(NSArray *)datasources;

@end
