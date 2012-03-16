//
//  WineryDetailViewController.m
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WineryDetailViewController.h"

#import "Winery.h"
#import "Hours.h"
#import "WeeklyHours.h"
#import "Singleton.h"
#import "Location.h"
#import "ContentAndStyle.h"

@interface WineryDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *name;
@property (weak, nonatomic) IBOutlet UILabel *uiOpenClosedLabel;
@property (weak, nonatomic) IBOutlet UILabel *uiHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *uiRateingLabel;
@property (weak, nonatomic) IBOutlet UITextView *uiDescription;


@property (weak, nonatomic) IBOutlet UIButton *uiFullHoursButton;
@property (weak, nonatomic) IBOutlet UIButton *uiRateButton;
@property (weak, nonatomic) IBOutlet UIButton *uiEventsButton;
@property (weak, nonatomic) IBOutlet UIButton *uiGalleryButton;

@property (weak, nonatomic) IBOutlet UIImageView *uiBackgrounImage;

@end

@implementation WineryDetailViewController

#pragma mark - Properties
@synthesize image;
@synthesize name;
@synthesize uiRateingLabel;
@synthesize uiDescription;
@synthesize uiFullHoursButton;
@synthesize uiRateButton;
@synthesize uiEventsButton;
@synthesize uiGalleryButton;
@synthesize uiBackgrounImage;

@synthesize uiOpenClosedLabel, uiHoursLabel, winery;

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

- (void) addToTrip:(id) sender
{
    NSMutableSet *trip = [Singleton shared].trip;
    if ([trip containsObject:self.winery])
    {
        [trip removeObject:self.winery];
        self.navigationItem.rightBarButtonItem.title = @"Add to Trip";
        NSString *routeString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",[Singleton shared].location.latitude,[Singleton shared].location.longitude,self.winery.location.coordinate.latitude, self.winery.location.coordinate.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:routeString]];
    }
    else 
    {
        [trip addObject:self.winery];
        self.navigationItem.rightBarButtonItem.title = @"Go";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if ([[Singleton shared].trip containsObject:self.winery])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(addToTrip:)];
    }
    else 
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add to Trip" style:UIBarButtonItemStyleDone target:self action:@selector(addToTrip:)];
    }

    // Do any additional setup after loading the view from its nib.
//    self.uiBackgrounImage.image = [UIImage imageNamed:@"wood"];
//    for (UIView* shadowView in [self.view subviews])
//    {
//        if ([shadowView isKindOfClass:[UIImageView class]]) 
//        {
//            shadowView.backgroundColor = [UIColor blueColor];
//        }
//    }
}

- (void)viewDidUnload
{
    [self setImage:nil];
    [self setName:nil];
    [self setUiDescription:nil];
    [self setUiFullHoursButton:nil];
    [self setUiRateButton:nil];
    [self setUiEventsButton:nil];
    [self setUiGalleryButton:nil];
    [self setUiRateingLabel:nil];
    [self setUiBackgrounImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    WeeklyHours *weeklyHours = self.winery.hours;
    Hours *todaysHours = [[Singleton shared] todaysHours:weeklyHours];
    // Find todays weekday
    
    //** Content **//
    self.image.image = self.winery.image;
    self.name.text = self.winery.name;
    if ([todaysHours class] != [NSNull class])
    {
//        NSDate *today = [NSDate date];
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"h:mma"];
        
        self.uiOpenClosedLabel.text = @"Open"; 
        self.uiOpenClosedLabel.textColor = STYLE_OPEN_COLOR;
        
//        NSDate *openTime = todaysHours.openTime;
//        NSString *formattedOpenTime = [dateFormat stringFromDate:openTime];
//        NSLog(@"%@ date: %@", openTime, formattedOpenTime);
        self.uiHoursLabel.text = [NSString stringWithFormat:@"%@ - %@", todaysHours.openTime, todaysHours.closeTime];
        
//        [theDateFormatter setDateFormat:@"hh:mma"];
//        self.uiHoursLabel.text = [NSString stringWithFormat:@"%@ - %@", [theDateFormatter stringFromDate:todaysHours.openTime], [theDateFormatter stringFromDate:todaysHours.closeTime]];
//        
        NSLog(@"%@ -- %@",todaysHours.openTime, todaysHours.closeTime);
        
        
    } else {
        self.uiOpenClosedLabel.text = @"Closed";
        self.uiOpenClosedLabel.textColor = STYLE_CLOSED_COLOR;
        self.uiHoursLabel.text = @"";
    }
    
    self.uiRateingLabel.text = [NSString stringWithFormat:@"%.1f%% Like", [self.winery.rating floatValue]];
    self.uiDescription.text = self.winery.description;
    
    
    //** Layout **//
    
    // Set height for textview based on content
    //-----------------------------------------------
    CGRect frame = self.uiDescription.frame;
    frame.size.height = self.uiDescription.contentSize.height;
    self.uiDescription.frame = frame;
    //-----------------------------------------------
    
    // Allign buttons based on description height
    //-----------------------------------------------
    CGFloat top = frame.origin.y + frame.size.height + 10;
    frame = self.uiFullHoursButton.frame;
    frame.origin.y = top;
    self.uiFullHoursButton.frame = frame;
    
//    top = frame.origin.y + frame.size.height + 10;
    frame = self.uiRateButton.frame;
    frame.origin.y = top;
    self.uiRateButton.frame = frame;
    
    top = frame.origin.y + frame.size.height + 10;
    frame = self.uiEventsButton.frame;
    frame.origin.y = top;
    self.uiEventsButton.frame = frame;
    
//    top = frame.origin.y + frame.size.height + 10;
    frame = self.uiGalleryButton.frame;
    frame.origin.y = top;
    self.uiGalleryButton.frame = frame;
    
    top += frame.size.height + 10;
    top = (top > 367) ? top : 367;
    UIScrollView *sv = (UIScrollView *)self.view;

    
    sv.contentSize = CGSizeMake(sv.contentSize.width, top);
    sv.bounces = NO;
    self.uiBackgrounImage.frame = CGRectMake(0, 0, 320, sv.contentSize.height);

    NSLog(@"%f, %f", sv.contentSize.width, sv.contentSize.height);
    //-----------------------------------------------
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Delegate Methods

#pragma mark - Methods

#pragma mark - Event Handlers (IBActions)


@end
