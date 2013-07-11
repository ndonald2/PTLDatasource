//
//  PTLAppDelegate.h
//  PTLDatasource Demo
//
//  Created by Brian Partridge on 7/10/13.
//  Copyright (c) 2013 Pear Tree labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTLViewController;

@interface PTLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PTLViewController *viewController;

@end
