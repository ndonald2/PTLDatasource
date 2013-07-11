//
//  PTLAppDelegate.m
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree Labs. All rights reserved.
//

#import "PTLAppDelegate.h"
#import "PTLFontFamilyPicker.h"
#import "PTLEnumTableViewController.h"
#import "PTLColorCollectionViewController.h"

@implementation PTLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    PTLFontFamilyPicker *fontVC = [[PTLFontFamilyPicker alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *fontNav = [[UINavigationController alloc] initWithRootViewController:fontVC];

    PTLEnumTableViewController *enumVC = [[PTLEnumTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *enumNav = [[UINavigationController alloc] initWithRootViewController:enumVC];

    PTLColorCollectionViewController *colorVC = [[PTLColorCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    UINavigationController *colorNav = [[UINavigationController alloc] initWithRootViewController:colorVC];

    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = @[fontNav, enumNav, colorVC];

    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
