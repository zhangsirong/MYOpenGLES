//
//  AppDelegate.m
//  MYOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MainViewController *rootVC = [[MainViewController alloc] init];
    _window.rootViewController = rootVC;
    [_window makeKeyAndVisible];
    return YES;
}

@end
