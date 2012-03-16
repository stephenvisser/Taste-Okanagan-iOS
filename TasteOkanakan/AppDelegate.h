//
//  AppDelegate.h
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "EventListViewController.h"
#import "WineryListViewController.h"
#import "WineryMapViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, DataSourceDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *manager;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) WineryListViewController *vcList;
@property (strong, nonatomic) WineryMapViewController *vcMap;
@property (strong, nonatomic) EventListViewController *vcEvents;


@end
