//
//  PTLMainViewController.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLFontFamilyPicker.h"
#import "PTLTableViewDatasource.h"
#import "PTLArraySection.h"

@interface PTLFontFamilyPicker ()

@property (nonatomic, strong) PTLTableViewDatasource *datasource;

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
    PTLArraySection *familySection = [[PTLArraySection alloc] initWithItems:fonts];
    familySection.title = @"Font Families";
    familySection.cellIdentifier = familyCellId;
    familySection.cellConfigBlock = ^(UITableView *tableView, UITableViewCell *cell, id item, NSIndexPath *indexPath) {
        NSString *familyName = item;
        cell.textLabel.text = familyName;
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        UIFont *font = [UIFont fontWithName:[fontNames lastObject] size:cell.textLabel.font.pointSize];
        cell.textLabel.font = font;
    };

    self.datasource = [[PTLTableViewDatasource alloc] initWithWithSections:@[familySection]];
    self.tableView.dataSource = self.datasource;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *familyName = [self.datasource itemAtIndexPath:indexPath];
    NSLog(@"picked: %@", familyName);
}

@end
