//
//  PTLDatasource+CollectionView.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLDatasource+CollectionView.h"
#import <objc/runtime.h>

@interface  PTLDatasource (CollectionView_Private)

@property (nonatomic, readonly, strong) NSMutableDictionary *indexPathToCollectionViewCellIdentifier;
@property (nonatomic, readonly, strong) NSMutableDictionary *indexPathToCollectionViewCellConfigBlock;
@property (nonatomic, readonly, strong) NSMutableDictionary *indexPathToCollectionViewSupplementaryViewIdentifier;
@property (nonatomic, readonly, strong) NSMutableDictionary *indexPathToCollectionViewSupplementaryViewConfigBlock;

@end

@implementation PTLDatasource (CollectionView)

#pragma mark - Properties

@dynamic collectionViewCellIdentifier;

- (NSString *)collectionViewCellIdentifier {
    return objc_getAssociatedObject(self, @"collectionViewCellIdentifier");
}

- (void)setCollectionViewCellIdentifier:(NSString *)collectionViewCellIdentifier {
    objc_setAssociatedObject(self, @"collectionViewCellIdentifier", collectionViewCellIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@dynamic collectionViewCellConfigBlock;

- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlock {
    return objc_getAssociatedObject(self, @"collectionViewCellConfigBlock");
}

- (void)setCollectionViewCellConfigBlock:(PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlock {
    objc_setAssociatedObject(self, @"collectionViewCellConfigBlock", collectionViewCellConfigBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@dynamic collectionViewSupplementaryViewIdentifier;

- (NSString *)collectionViewSupplementaryViewIdentifier {
    return objc_getAssociatedObject(self, @"collectionViewSupplementaryViewIdentifier");
}

- (void)setCollectionViewSupplementaryViewIdentifier:(NSString *)collectionViewSupplementaryViewIdentifier {
    objc_setAssociatedObject(self, @"collectionViewSupplementaryViewIdentifier", collectionViewSupplementaryViewIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@dynamic collectionViewSupplementaryViewConfigBlock;

- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlock {
    return objc_getAssociatedObject(self, @"collectionViewSupplementaryViewConfigBlock");
}

- (void)setCollectionViewSupplementaryViewConfigBlock:(PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlock {
    objc_setAssociatedObject(self, @"collectionViewSupplementaryViewConfigBlock", collectionViewSupplementaryViewConfigBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Setters

- (void)setCollectionViewCellIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    [self.indexPathToCollectionViewCellIdentifier setObject:identifier forKey:indexPath];
}

- (void)setCollectionViewCellConfigBlock:(PTLCollectionViewCellConfigBlock)block forIndexPath:(NSIndexPath *)indexPath {
    [self.indexPathToCollectionViewCellConfigBlock setObject:[block copy] forKey:indexPath];
}

- (void)setCollectionViewSupplementaryViewIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    [self.indexPathToCollectionViewSupplementaryViewIdentifier setObject:identifier forKey:indexPath];
}
- (void)setCollectionViewSupplementaryViewConfigBlock:(PTLCollectionViewSupplementaryViewConfigBlock)block forIndexPath:(NSIndexPath *)indexPath {
    [self.indexPathToCollectionViewSupplementaryViewConfigBlock setObject:[block copy] forKey:indexPath];
}

#pragma mark - Getters

- (NSString *)collectionViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.indexPathToCollectionViewCellIdentifier objectForKey:indexPath];
    if (identifier == nil) {
        identifier = self.collectionViewCellIdentifier;
    }
    return identifier;
}

- (PTLCollectionViewCellConfigBlock)collectionViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    PTLCollectionViewCellConfigBlock block = [self.indexPathToCollectionViewCellConfigBlock objectForKey:indexPath];
    if (block == nil) {
        block = self.collectionViewCellConfigBlock;
    }
    return block;
}

- (NSString *)collectionViewSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.indexPathToCollectionViewSupplementaryViewIdentifier objectForKey:indexPath];
    if (identifier == nil) {
        identifier = self.collectionViewSupplementaryViewIdentifier;
    }
    return identifier;
}

- (PTLCollectionViewSupplementaryViewConfigBlock)collectionViewSupplementaryViewConfigBlockForIndexPath:(NSIndexPath *)indexPath {
    PTLCollectionViewSupplementaryViewConfigBlock block = [self.indexPathToCollectionViewSupplementaryViewConfigBlock objectForKey:indexPath];
    if (block == nil) {
        block = self.collectionViewSupplementaryViewConfigBlock;
    }
    return block;
}

@end

@implementation PTLDatasource (CollectionView_Private)

@dynamic indexPathToCollectionViewCellIdentifier;

- (NSMutableDictionary *)indexPathToCollectionViewCellIdentifier {
    NSMutableDictionary *result = objc_getAssociatedObject(self, @"indexPathToCollectionViewCellIdentifier");
    if (result == nil) {
        objc_setAssociatedObject(self, @"indexPathToCollectionViewCellIdentifier", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

@dynamic indexPathToCollectionViewCellConfigBlock;

- (NSMutableDictionary *)indexPathToCollectionViewCellConfigBlock {
    NSMutableDictionary *result = objc_getAssociatedObject(self, @"indexPathToCollectionViewCellConfigBlock");
    if (result == nil) {
        objc_setAssociatedObject(self, @"indexPathToCollectionViewCellConfigBlock", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

@dynamic indexPathToCollectionViewSupplementaryViewIdentifier;

- (NSMutableDictionary *)indexPathToCollectionViewSupplementaryViewIdentifier {
    NSMutableDictionary *result = objc_getAssociatedObject(self, @"indexPathToCollectionViewSupplementaryViewIdentifier");
    if (result == nil) {
        objc_setAssociatedObject(self, @"indexPathToCollectionViewSupplementaryViewIdentifier", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

@dynamic indexPathToCollectionViewSupplementaryViewConfigBlock;

- (NSMutableDictionary *)indexPathToCollectionViewSupplementaryViewConfigBlock {
    NSMutableDictionary *result = objc_getAssociatedObject(self, @"indexPathToCollectionViewSupplementaryViewConfigBlock");
    if (result == nil) {
        objc_setAssociatedObject(self, @"indexPathToCollectionViewSupplementaryViewConfigBlock", result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}


@end
