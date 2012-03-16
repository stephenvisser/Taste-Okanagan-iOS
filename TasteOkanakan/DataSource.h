//
//  DataSource.h
//  Taste Okanagan
//
//  Created by Stephen Visser on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Winery;

@protocol DataSourceDelegate <NSObject>

- (void) retrievedWineries: (NSArray *) data;
- (void) retrievedEvents: (NSArray *) data;

@end

@interface DataSource : NSObject

@property (nonatomic, weak) id<DataSourceDelegate> delegate;
- (void) get;

@end
