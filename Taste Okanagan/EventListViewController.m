//
//  EventListViewController.m
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventListViewController.h"

@interface EventListViewController ()

@end

@implementation EventListViewController

#pragma mark - Properties

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Delegate Methods

#pragma mark - Methods

#pragma mark - Event Handlers (IBActions)


@end
