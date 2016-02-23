//
//  AppDelegate.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "AppDelegate.h"
#import "ThemeManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <CocoaLumberjack/DDFileLogger.h>
#import <AFNetworkReachabilityManager.h>
#import "PromotionViewController.h"
#import "CoreDataHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : [UIColor blackColor],
                                                           NSFontAttributeName :
                                                               [ThemeManager navigationBarFont]}];
    
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [ThemeManager navigationBarFont],
                                              NSForegroundColorAttributeName: [UIColor blackColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
    
    
    PromotionViewController *baseViewController = [[PromotionViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController: baseViewController];
    self.navigationController.navigationBar.translucent = NO;
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    // monitoring to get notifications to check internet connectivity
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    CoreDataHelper *coreDataHelper =  [CoreDataHelper sharedInstance];
    NSError *error=nil;
    [coreDataHelper.context save:&error];
}

#pragma mark - Core Data stack


@end
