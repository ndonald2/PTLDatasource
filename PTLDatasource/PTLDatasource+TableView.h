//
//  PTLDatasource+TableView.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/11/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTLDatasource.h"

typedef void(^PTLTableViewCellConfigBlock)(UITableView *tableView, UITableViewCell *cell, id item, NSIndexPath *indexPath);

#pragma mark - Protocol

@protocol PTLTableViewDatasource <PTLDatasource, PTLMutableDatasource, PTLObservableDatasource>

- (NSString *)tableViewCellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (PTLTableViewCellConfigBlock)tableViewCellConfigBlockForIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSString *)titleForSection:(NSInteger)sectionIndex;
- (NSString *)subtitleForSection:(NSInteger)sectionIndex;
- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - Implementation

@interface PTLDatasource (TableView) <PTLTableViewDatasource>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CGFloat tableViewCellHeight;
@property (nonatomic, copy) NSString *tableViewCellIdentifier;
@property (nonatomic, copy) PTLTableViewCellConfigBlock tableViewCellConfigBlock;

- (void)setTitle:(NSString *)title forSection:(NSInteger)sectionIndex;
- (void)setSubtitle:(NSString *)subtitle forSection:(NSInteger)sectionIndex;
- (void)setTableViewCellHeight:(CGFloat)height forIndexPath:(NSIndexPath *)indexPath;
- (void)setTableViewCellIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)setTableViewCellConfigBlock:(PTLTableViewCellConfigBlock)block forIndexPath:(NSIndexPath *)indexPath;

@end
