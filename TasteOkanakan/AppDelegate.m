//
//  AppDelegate.m
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "WineryListViewController.h"
#import "WineryMapViewController.h"
#import "EventListViewController.h"
#import "DataSource.h"
#import "Winery.h"
#import "Singleton.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

@synthesize vcMap,vcList,vcEvents, manager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.manager startMonitoringSignificantLocationChanges];

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];	
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.vcList = [[WineryListViewController alloc] initWithNibName:@"WineryListViewController_iPhone" bundle:nil];
    self.vcMap = [[WineryMapViewController alloc] initWithNibName:@"WineryMapViewController_iPhone" bundle:nil];
    self.vcEvents = [[EventListViewController alloc] initWithNibName:@"EventListViewController_iPhone" bundle:nil];

    UINavigationController *vcNavList, *vcNavEvents, *vcNavMap;
    vcNavList = [[UINavigationController alloc] initWithRootViewController:vcList];
    vcNavList.navigationBar.barStyle = UIBarStyleBlackOpaque;
    vcNavMap = [[UINavigationController alloc] initWithRootViewController:vcMap];
    vcNavMap.navigationBar.barStyle = UIBarStyleBlackOpaque;
    vcNavEvents = [[UINavigationController alloc] initWithRootViewController:vcEvents];
    vcNavEvents.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    vcNavList.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Wineries" image:[UIImage imageNamed:@"events"] tag:0];
    vcNavMap.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"map"] tag:0];
    vcNavEvents.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:[UIImage imageNamed:@"list"] tag:0];
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:vcNavList, vcNavMap, vcNavEvents, nil];
    self.tabBarController.selectedIndex = 1;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
        
    DataSource *data = [[DataSource alloc] init];
    data.delegate = self;
    [data get];
    
    //This is for the push notifications!
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
    
    
    UIImageView *adView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adred"]];
    adView.frame = CGRectMake(0, 0, 320, 480);
    adView.alpha = 0;
    [self.tabBarController.view addSubview:adView];
    [UIView animateWithDuration:0.4 animations:^{
        adView.alpha = 1;
    }];
    
    [self performSelector:@selector(killAd:) withObject:adView afterDelay:3.0];
    return YES;
}
     
- (void)killAd:(UIView *)view
{
    [UIView animateWithDuration:0.8f animations:^{
        view.alpha = 0;
    } completion:^(BOOL f){[view removeFromSuperview];}];
}

//This is called when the GPS hardware gets a fix. Once we've stored the location,
//we can stop the updating process to save battery
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [Singleton shared].location = newLocation.coordinate;
    [self.manager stopMonitoringSignificantLocationChanges];
}

-(void)retrievedWineries:(NSArray *)data
{
    self.vcList.wineries = data;
    self.vcMap.wineries = data;
    self.vcEvents.wineries = data;
}

- (void) retrievedEvents:(NSArray *)data
{
    self.vcEvents.events = data;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [[[UIAlertView alloc] initWithTitle:@"Notifications" message:[@"Registered with token: " stringByAppendingString:[deviceToken description]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    [[[UIAlertView alloc] initWithTitle:@"Notifications" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[[UIAlertView alloc] initWithTitle:@"Specials" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
