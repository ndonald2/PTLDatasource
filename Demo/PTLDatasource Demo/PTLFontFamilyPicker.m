//
//  PTLMainViewController.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLFontFamilyPicker.h"
#import "PTLArrayDatasource.h"
#import "PTLTableViewDatasourceAdapter.h"

@interface PTLFontFamilyPicker ()

@property (nonatomic, strong) PTLTableViewDatasourceAdapter *datasource;

@end

@implementation PTLFontFamilyPicker

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Array";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *familyCellId = @"family";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:familyCellId];

    NSArray *fonts = [[UIFont familyNames] sortedArrayUsingSelector:@selector(compare:)];
    PTLArrayDatasource *familyDatasource = [[PTLArrayDatasource alloc] initWithItems:fonts];
    familyDatasource.tableViewSectionHeaderTitle = @"Font Families";
    familyDatasource.tableViewCellIdentifier = familyCellId;
    familyDatasource.tableViewCellConfigBlock = ^(UITableView *tableView, UITableViewCell *cell, NSString *familyName, NSIndexPath *indexPath) {
        cell.textLabel.text = familyName;
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        UIFont *font = [UIFont fontWithName:[fontNames lastObject] size:cell.textLabel.font.pointSize];
        cell.textLabel.font = font;
    };

    self.datasource = [[PTLTableViewDatasourceAdapter alloc] initWithDatasource:familyDatasource];
    self.tableView.dataSource = self.datasource;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *familyName = [self.datasource itemAtIndexPath:indexPath];
    NSLog(@"picked: %@", familyName);
}

@end
