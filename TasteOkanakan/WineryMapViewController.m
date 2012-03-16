//
//  WineryMapViewController.m
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WineryMapViewController.h"
#import "Winery.h"
#import "Location.h"
#import "WineryDetailViewController.h"
#import "Singleton.h"

@interface WineryMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation WineryMapViewController

#pragma mark - Properties
@synthesize mapView = _mapView, wineries=_wineries;

#pragma mark - Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _wineries = [[NSArray alloc] init];
        // Custom initialization
        
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 49.527883;
    coordinate.longitude = -119.564037;
    self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 15000, 15000);
    
    
    NSMutableArray *pins = [NSMutableArray array];
    
    for(Winery *winery in self.wineries) {
        [pins addObject:winery.location];
    }
    
    [self.mapView addAnnotations:pins];
    
    self.navigationItem.title = @"Taste Okanagan";
}

- (void)setWineries:(NSArray *)wineries
{
    _wineries = wineries;
    if (self.isViewLoaded)
    {
        NSMutableArray *pins = [NSMutableArray array];
        
        for(Winery *winery in self.wineries) {
            [pins addObject:winery.location];
        }
        
        [self.mapView addAnnotations:pins];
    }
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Delegate Methods

#pragma makr - Map View Delegate

- (void) showDetails:(id) source
{
    Winery *winery = nil;
    for (id<MKAnnotation> annotation in self.mapView.annotations)
    {
        if ([self.mapView viewForAnnotation:annotation].rightCalloutAccessoryView == source)
        {
            winery = ((Location *)annotation).winery;
        }
    }
    WineryDetailViewController *vcWineryDetails = [[WineryDetailViewController alloc] initWithNibName:@"WineryDetailViewController_iPhone" bundle:nil];
    vcWineryDetails.winery = winery;
    [self.navigationController pushViewController:vcWineryDetails animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation class] == MKUserLocation.class) {
		//userLocation = annotation;
		return nil;
	}
    
   MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
    
    if( !view )
    {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];
        view.animatesDrop = YES;
        Hours *hours = [[Singleton shared] todaysHours:((Location *)annotation).winery.hours];
        if (hours != (Hours *)[NSNull null])
        {
            view.pinColor = MKPinAnnotationColorGreen;
        }
        view.canShowCallout = YES;
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        view.rightCalloutAccessoryView = rightButton;
    }
    return view;
}

#pragma mark - Methods

#pragma mark - Event Handlers (IBActions)


@end
