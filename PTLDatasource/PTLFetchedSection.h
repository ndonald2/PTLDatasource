//
//  PTLFetchedSection.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PTLDatasource.h"

#ifdef _COREDATADEFINES_H

@interface PTLFetchedSection : NSObject <PTLDatasource>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithFetchedResults:(NSFetchedResultsController *)controller;

@end

#endif
