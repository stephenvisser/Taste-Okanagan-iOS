//
//  Singleton.m
//  Taste Okanagan
//
//  Created by Stephen Visser on 12-03-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"
#import "Hours.h"
#import "WeeklyHours.h"
#import <CoreLocation/CoreLocation.h>

@interface Singleton()

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation Singleton

static Singleton *main = nil;

@synthesize trip, location, formatter;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.trip = [[NSMutableSet alloc] init];
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [self.formatter setDateFormat:@"EEEE"];
        self.location = CLLocationCoordinate2DMake(49.888718,-119.494944);
    }
    return self;
}

- (Hours *) todaysHours: (WeeklyHours *) hours
{
    Hours *todaysHours;
    
    // Find todays weekday
    NSString *weekDay =  [self.formatter stringFromDate:[NSDate date]];
    if ([weekDay caseInsensitiveCompare:@"Sunday"] == NSOrderedSame)
    {
        todaysHours = hours.sunday;
    } else if ([weekDay caseInsensitiveCompare:@"Monday"] == NSOrderedSame) {
        todaysHours = hours.monday;
    } else if ([weekDay caseInsensitiveCompare:@"Tuesday"] == NSOrderedSame) {
        todaysHours = hours.tuesday;
    } else if ([weekDay caseInsensitiveCompare:@"Wednesday"] == NSOrderedSame) {
        todaysHours = hours.wednesday;
    } else if ([weekDay caseInsensitiveCompare:@"Thursday"] == NSOrderedSame) {
        todaysHours = hours.thursday;
    } else if ([weekDay caseInsensitiveCompare:@"Friday"] == NSOrderedSame) {
        todaysHours = hours.friday;
    } else if ([weekDay caseInsensitiveCompare:@"Saturday"] == NSOrderedSame) {
        todaysHours = hours.saturday;
    }
    
    return todaysHours;
}

+ (Singleton *) shared
{
    if (!main)
    {
        main = [[Singleton alloc] init];
    }
    return main;
}
@end
