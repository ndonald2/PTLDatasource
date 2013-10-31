//
//  PTLIndexPathMappingDelta.h
//  PTLDatasource
//
//  Created by Brian Partridge on 10/31/13.
//
//

#import <Foundation/Foundation.h>

@interface PTLIndexPathMappingDelta : NSObject

@property (nonatomic, strong) NSArray *removedItemIndeciesBySection;
@property (nonatomic, strong) NSArray *addedItemIndeciesBySection;

@end
