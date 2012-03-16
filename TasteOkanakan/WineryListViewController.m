//
//  WineryListViewController.m
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WineryListViewController.h"

#import "WineryDetailViewController.h"
#import "Winery.h"
#import "Singleton.h"
#import "Location.h"
#import "ContentAndStyle.h"

@interface WineryListViewController ()

@property (strong, nonatomic) NSMutableArray *filteredWineries;

@end

@implementation WineryListViewController

#pragma mark - Properties

@synthesize uiWinerysTable, wineries=_wineries, filteredWineries, actIndView;

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filteredWineries = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setWineries:(NSArray *)wineries
{
    _wineries = wineries;
    [self.filteredWineries addObjectsFromArray:wineries];
    
    if (self.isViewLoaded)
    {
        [self.actIndView removeFromSuperview];
        self.actIndView = nil;
        [self.uiWinerysTable reloadData];
    }
}

#pragma mark - View Lifecycle

- (void) createTrip: (id) sender
{
    if (self.uiWinerysTable.isEditing)
    {
        [self.uiWinerysTable setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"Trip";
    }
    else
    {
        [self.uiWinerysTable setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"GO!";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //If the data hasn't loaded from the server yet....
    if (!self.wineries)
    {
        //Add an activity indicator in the meantime
        self.actIndView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.actIndView.frame = CGRectMake((self.view.bounds.size.width - actIndView.frame.size.width) / 2, (self.view.bounds.size.height - actIndView.frame.size.height) / 2, actIndView.frame.size.width, actIndView.frame.size.height);
        [self.view addSubview:self.actIndView];
    }
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = CONTENT_APP_TITLE;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Trip" style:UIBarButtonItemStyleDone target:self action:@selector(createTrip:)];
    
    self.uiWinerysTable.allowsSelectionDuringEditing = YES;
}

- (void)viewDidUnload
{
    [self setUiWinerysTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Delegate Methods

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WineryDetailViewController *vcWineryDetails;
    if (tableView.isEditing)
    {
        Winery *winery = [self.filteredWineries objectAtIndex:indexPath.row];
        
        NSMutableSet *trip = [Singleton shared].trip;
        if ([trip containsObject:winery])
        {
            [trip removeObject:winery];
            [tableView cellForRowAtIndexPath:indexPath].editingAccessoryType = UITableViewCellAccessoryNone;
        }
        else 
        {
            [trip addObject:winery];
            [tableView cellForRowAtIndexPath:indexPath].editingAccessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else 
    {
        vcWineryDetails = [[WineryDetailViewController alloc] initWithNibName:@"WineryDetailViewController_iPhone" bundle:nil];
        vcWineryDetails.winery = [self.filteredWineries objectAtIndex:indexPath.row];
    }
    
    [self.navigationController pushViewController:vcWineryDetails animated:YES];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
//{    
//    if (editingStyle == UITableViewCellEditingStyleDelete) 
//    {
//        
//    }   
//}


#pragma mark - Table View Data Source Methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	return 1;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	return ;
//}

// Return the number of rows for the section
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section 
{
    if (table == self.uiWinerysTable) {
        return [self.wineries count];
    } else if (table == self.searchDisplayController.searchResultsTableView){
        return [self.filteredWineries count];
    }
    
    return 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    //** Set up Resuable Cells **//
    static NSString *CELL_IDENT = @"SOME_CELL_IDENT";
    
    Winery *winery = [self.wineries objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENT];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENT];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([[Singleton shared].trip containsObject:winery])
        {
            cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
        }
        else 
        {
            cell.editingAccessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    
    if (tableView == self.uiWinerysTable) {
        cell.textLabel.text = winery.name;    
    } if (tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text = winery.name;    
    }    
    //** Set Cell Content **//
	return cell;
}

#pragma mark - Search Bar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.filteredWineries removeAllObjects];
    
    if ([searchText length] == 0)
    {
        [self.filteredWineries addObjectsFromArray:self.wineries];
    }
    else 
    {
        for (NSString *item in self.wineries)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)", searchText];
            [item compare:searchText options:NSCaseInsensitiveSearch];
            BOOL result = [predicate evaluateWithObject:item];
            //            BOOL resultName = [predicate evaluateWithObject:product.productName];
            if (result)
            {
                [self.filteredWineries addObject:item];
            }
            
            //            NSRange range = [item rangeOfString:searchText options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
            //            if (range.location != NSNotFound)
            //            {
            //                [self.filteredWineries addObject:item];
            //            }
        }
    }
}

#pragma mark - Methods

#pragma mark - Event Handlers (IBActions)


@end
