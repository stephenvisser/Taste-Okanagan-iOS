//
//  WineryListViewController.m
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WineryListViewController.h"

#import "WineryDetailViewController.h"

@interface WineryListViewController ()

@end

@implementation WineryListViewController

#pragma mark - Properties

@synthesize vcWineryDetails;
@synthesize uiWinerysTable;

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(filter_action)];
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    if (!self.vcWineryDetails)
    {
        if (IS_IPHONE)
        {
            self.vcWineryDetails = [[WineryDetailViewController alloc] initWithNibName:@"WineryDetailViewController_iPhone" bundle:nil];
        } else {
            //TODO IPAD
        }
    }

    [self.navigationController pushViewController:self.vcWineryDetails animated:YES];
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
        return 10;
    } else {
        // Search results table?
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
    
    //** Set Cell Content **//
    cell.textLabel.text = @"Misson Hill";
    
	return cell;
}


#pragma mark - Methods

#pragma mark - Event Handlers (IBActions)

- (void)filter_action
{
    
}

@end
