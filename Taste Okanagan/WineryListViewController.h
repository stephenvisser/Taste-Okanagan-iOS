//
//  WineryListViewController.h
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WineryDetailViewController;

@interface WineryListViewController : UIViewController

@property (strong, nonatomic) WineryDetailViewController *vcWineryDetails;

@property (weak, nonatomic) IBOutlet UITableView *uiWinerysTable;

@end
