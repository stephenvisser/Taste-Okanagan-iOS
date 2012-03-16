//
//  WeeklyHours.h
//  Taste Okanagan
//
//  Created by Stephen Visser on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hours;

@interface WeeklyHours : NSObject

@property (nonatomic, strong) Hours *monday;
@property (nonatomic, strong) Hours *tuesday;
@property (nonatomic, strong) Hours *wednesday;
@property (nonatomic, strong) Hours *thursday;
@property (nonatomic, strong) Hours *friday;
@property (nonatomic, strong) Hours *saturday;
@property (nonatomic, strong) Hours *sunday;

@end
