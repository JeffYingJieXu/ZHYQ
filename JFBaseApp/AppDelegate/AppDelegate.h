//
//  AppDelegate.h
//  JFBaseApp
//
//  Created by Jeff Xu on 2019/4/18.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainTabBarController *mainTabBar;

@end

