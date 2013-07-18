//
//  PTLEnumTableViewController.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EyeColor) {
    EyeColorBlue,
    EyeColorGreen,
    EyeColorBrown,
    EyeColorCount
};

typedef NS_ENUM(NSInteger, HairColor) {
    HairColorBrown,
    HairColorBlack,
    HairColorBlonde,
    HairColorRed,
    HairColorCount
};

@interface PTLEnumTableViewController : UITableViewController

@end
