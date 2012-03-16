//
//  Singleton.h
//  Taste Okanagan
//
//  Created by Stephen Visser on 12-03-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class Hours;
@class WeeklyHours;

@interface Singleton : NSObject

@property (nonatomic, strong) NSMutableSet *trip;
@property (nonatomic) CLLocationCoordinate2D location;

- (Hours *) todaysHours: (WeeklyHours *) hours;

+ (Singleton *) shared;

@end
