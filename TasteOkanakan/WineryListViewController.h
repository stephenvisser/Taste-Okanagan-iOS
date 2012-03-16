//
//  WineryListViewController.h
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WineryDetailViewController;

@interface WineryListViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *wineries;

@property (weak, nonatomic) IBOutlet UITableView *uiWinerysTable;
@property (nonatomic, strong) UIActivityIndicatorView *actIndView;

@end
