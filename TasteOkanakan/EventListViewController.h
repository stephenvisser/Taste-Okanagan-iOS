//
//  EventListViewController.h
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WineryDetailViewController;

@interface EventListViewController : UIViewController

@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSArray *wineries;

@end
