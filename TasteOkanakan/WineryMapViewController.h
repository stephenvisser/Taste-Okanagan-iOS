//
//  WineryMapViewController.h
//  Taste Okanagan
//
//  Created by Jo-el van Bergen on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class WineryDetailViewController;

@interface WineryMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *wineries;

@end
