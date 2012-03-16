//
//  Location.m
//  Taste Okanagan
//
//  Created by Stephen Visser on 12-03-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Location.h"
#import "Winery.h"

@implementation Location

@synthesize latitude, longitude,winery;

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude.floatValue, self.longitude.floatValue);
}

- (NSString *)title
{
    return self.winery.name;
}

@end
