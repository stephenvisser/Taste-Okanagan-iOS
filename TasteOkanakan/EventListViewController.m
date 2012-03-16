//
//  EventListViewController.m
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventListViewController.h"
#import "ContentAndStyle.h"
#import "WineryDetailViewController.h"
#import "Event.h"

@interface EventListViewController ()

@property (strong, nonatomic) NSMutableArray *filteredEvents;
@property (weak, nonatomic) IBOutlet UITableView *uiEventTable;

@end

@implementation EventListViewController

#pragma mark - Properties

@synthesize uiEventTable, events=_events, filteredEvents, wineries=_wineries;

#pragma mark - Initializers


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = CONTENT_APP_TITLE;
    }
    return self;
}

- (void)setEvents:(NSArray *)events
{
    _events = events;
    if (self.isViewLoaded)
    {
        [self.filteredEvents addObjectsFromArray:events];
        [self.uiEventTable reloadData];
    }
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];

}

- (void)viewDidUnload
{
    [self setUiEventTable:nil];
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
    
    Event *selectedEvent = [self.events objectAtIndex:indexPath.row];
    
    WineryDetailViewController *vcWineryDetails;
    vcWineryDetails = [[WineryDetailViewController alloc] initWithNibName:@"WineryDetailViewController_iPhone" bundle:nil];
    for (Winery *winery in self.wineries)
    {
        if ([winery.__id isEqualToNumber:selectedEvent.winery.__id])
        {
            vcWineryDetails.winery = winery;
            break;
        }
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
    if (table == self.uiEventTable) {
        return [self.events count];
    } else if (table == self.searchDisplayController.searchResultsTableView){
        return [self.filteredEvents count];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    //** Set up Resuable Cells **//
    static NSString *CELL_IDENT = @"SOME_CELL_IDENT";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENT];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENT];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    if (tableView == self.uiEventTable) {
        cell.textLabel.text = ((Event *)[self.events objectAtIndex:indexPath.row]).name;    
    } if (tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text = ((Event *)[self.filteredEvents objectAtIndex:indexPath.row]).name;    
    }    
    //** Set Cell Content **//
	return cell;
}

#pragma mark - Search Bar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.filteredEvents removeAllObjects];
    
    if ([searchText length] == 0)
    {
        [self.filteredEvents addObjectsFromArray:self.events];
    }
    else 
    {
        for (Event *item in self.events)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)", searchText];
            BOOL result = [predicate evaluateWithObject:item.name];
            if (result)
            {
                [self.filteredEvents addObject:item];
            }
        }
    }
}

#pragma mark - Methods

#pragma mark - Event Handlers (IBActions)


@end
