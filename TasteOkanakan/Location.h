//
//  Location.h
//  Taste Okanagan
//
//  Created by Stephen Visser on 12-03-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Winery;

@interface Location : NSObject <MKAnnotation>
{
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) Winery *winery;

@end
