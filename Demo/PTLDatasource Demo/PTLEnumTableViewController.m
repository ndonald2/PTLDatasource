//
//  PTLEnumTableViewController.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLEnumTableViewController.h"
#import "UIKit+PTLDatasource.h"

@interface PTLEnumTableViewController ()

@property (nonatomic, strong) PTLDatasource *datasource;

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

- (UIColor *)colorForEyeColor:(EyeColor)color {
    switch (color) {
        case EyeColorBlue:
            return [UIColor blueColor];
            break;
        case EyeColorGreen:
            return [UIColor greenColor];
            break;
        case EyeColorBrown:
            return [UIColor brownColor];
            break;
        default:
            break;
    }
    return nil;
}

- (UIColor *)colorForHairColor:(HairColor)color {
    switch (color) {
        case HairColorBrown:
            return [UIColor brownColor];
            break;
        case HairColorBlack:
            return [UIColor blackColor];
            break;
        case HairColorBlonde:
            return [UIColor yellowColor];
            break;
        case HairColorRed:
            return [UIColor redColor];
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

    PTLIndexDatasource *eyesSection = [[PTLIndexDatasource alloc] initWithIndecies:eyes];
    eyesSection.tableViewHeaderTitle = @"Eyes";
    eyesSection.tableViewCellIdentifier = cellId;
    eyesSection.tableViewCellConfigBlock = ^(UITableView *tableView, UITableViewCell *cell, NSNumber *item, NSIndexPath *indexPath) {
        cell.textLabel.text = [self nameForEyeColor:item.integerValue];
        cell.textLabel.textColor = [self colorForEyeColor:item.integerValue];
    };

    PTLIndexDatasource *hairSection = [[PTLIndexDatasource alloc] initWithIndecies:hair];
    hairSection.tableViewHeaderTitle = @"Hair";
    hairSection.tableViewCellIdentifier = cellId;
    hairSection.tableViewCellConfigBlock = ^(UITableView *tableView, UITableViewCell *cell, NSNumber *item, NSIndexPath *indexPath) {
        cell.textLabel.text = [self nameForHairColor:item.integerValue];
        cell.textLabel.textColor = [self colorForHairColor:item.integerValue];
    };

    self.datasource = [[PTLCompositeDatasource alloc] initWithWithDatasources:@[eyesSection, hairSection]];
    self.tableView.dataSource = self.datasource;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id item = [self.datasource itemAtIndexPath:indexPath];
    NSLog(@"picked: %@", item);
}

@end
