//
//  PTLEnumTableViewController.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Brian Partridge. All rights reserved.
//

#import "PTLEnumTableViewController.h"
#import "PTLTableViewDatasource.h"
#import "PTLIndexSection.h"

@interface PTLEnumTableViewController ()

@property (nonatomic, strong) PTLTableViewDatasource *datasource;

@end

@implementation PTLEnumTableViewController

- (NSString *)nameForEyeColor:(EyeColor)color {
    switch (color) {
        case EyeColorBlue:
            return @"Blue";
            break;
        case EyeColorGreen:
            return @"Green";
            break;
        case EyeColorBrown:
            return @"Brown";
            break;
        default:
            break;
    }
    return nil;
}

- (NSString *)nameForHairColor:(HairColor)color {
    switch (color) {
        case HairColorBrown:
            return @"Brown";
            break;
        case HairColorBlack:
            return @"Black";
            break;
        case HairColorBlonde:
            return @"Blonde";
            break;
        case HairColorRed:
            return @"Red";
            break;
        default:
            break;
    }
    return nil;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Enum";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *cellId = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];

    NSIndexSet *eyes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, EyeColorCount)];
    NSIndexSet *hair = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, HairColorCount)];

    PTLIndexSection *eyesSection = [[PTLIndexSection alloc] initWithIndecies:eyes];
    eyesSection.title = @"Eyes";
    eyesSection.cellIdentifier = cellId;
    eyesSection.cellConfigBlock = ^(UITableView *tableView, UITableViewCell *cell, NSNumber *item, NSIndexPath *indexPath) {
        cell.textLabel.text = [self nameForEyeColor:item.integerValue];
    };

    PTLIndexSection *hairSection = [[PTLIndexSection alloc] initWithIndecies:hair];
    hairSection.title = @"Hair";
    hairSection.cellIdentifier = cellId;
    hairSection.cellConfigBlock = ^(UITableView *tableView, UITableViewCell *cell, NSNumber *item, NSIndexPath *indexPath) {
        cell.textLabel.text = [self nameForHairColor:item.integerValue];
    };

    self.datasource = [[PTLTableViewDatasource alloc] initWithWithSections:@[eyesSection, hairSection]];
    self.tableView.dataSource = self.datasource;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id item = [self.datasource itemAtIndexPath:indexPath];
    NSLog(@"picked: %@", item);
}

@end
