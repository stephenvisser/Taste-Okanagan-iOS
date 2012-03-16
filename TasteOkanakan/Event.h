//
//  Event.h
//  Taste Okanagan
//
//  Created by Stephen Visser on 12-03-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Winery.h"

@interface Event : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) Winery *winery;
@end
