//
//  Winery.h
//  Taste Okanagan
//
//  Created by Stephen Visser on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;
@class WeeklyHours;

@interface Winery : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) WeeklyHours *hours;
@property (nonatomic, strong) NSNumber *__id;

@end
