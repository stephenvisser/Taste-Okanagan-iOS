//
//  DataSource.m
//  Taste Okanagan
//
//  Created by Stephen Visser on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataSource.h"
#import "Winery.h"
#import "Event.h"
#import "Location.h"
#import "Base64.h"

static NSString *const RemoteObjectClass = @"__class";
static NSString *const RemoteIdClass = @"__id";

@implementation DataSource

@synthesize delegate;

- (void) populateObject:(id) object withValues: (NSDictionary *) dictionary
{
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqualToString:RemoteObjectClass])
        {
            return;
        }
        else if ([key isEqualToString:RemoteIdClass])
        {
            if ([object respondsToSelector:@selector(set__id:)])
            {
                [object performSelector:@selector(set__id:) withObject:obj];
            }
        }
        else
        {
            [self deserializeValue:obj withKey:key onObject: object];
        }
    }];
}

- (void) deserializeValue:(id) jsonObject withKey:(NSString *)key onObject: (id) object
{   
    if ([key isEqualToString:@"image"])
    {
        [object performSelector:@selector(setImage:) withObject:[UIImage imageWithData:[Base64 decodeBase64WithString:jsonObject]]];
    }
    else if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        id actualValue = [[NSClassFromString([jsonObject valueForKey:RemoteObjectClass]) alloc] init];
        [self populateObject:actualValue withValues:jsonObject];
        [object setValue:actualValue forKey:key];
        
        //The location tags should have information about the parent winery
        if ([actualValue isKindOfClass:[Location class]])
        {
            ((Location *)actualValue).winery = object;
        }
    }
    else if ([jsonObject isKindOfClass:[NSArray class]])
    {
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:[(NSArray *)jsonObject count]];
        
        for (id object in (NSArray *)jsonObject)
        {
            if ([object isKindOfClass:[NSDictionary class]])
            {
                id newObject = [[NSClassFromString([object valueForKey:RemoteObjectClass]) alloc] init];
                [self populateObject:newObject withValues:object];
                [newArray addObject:newObject];
            }
            else
            {
                [newArray addObject:object];
            }
        }
        [object setValue:newArray forKey:key];
    }
    else
    {
        [object setValue:jsonObject forKey:key];
    }
    
}

- (void) get
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://tasteokanagan.appspot.com/api/Winery"]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {    
        NSArray  *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
        
        for (NSDictionary *dict in array)
        {
            Winery *theObject = [[NSClassFromString([dict objectForKey:RemoteObjectClass]) alloc] init];
            [self populateObject:theObject withValues:dict];
            [newArray addObject:theObject];
        }
        
        [self.delegate retrievedWineries:newArray];
    }];

    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://tasteokanagan.appspot.com/api/Event"]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {    
        NSArray  *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
        
        for (NSDictionary *dict in array)
        {
            Event *theObject = [[NSClassFromString([dict objectForKey:RemoteObjectClass]) alloc] init];
            [self populateObject:theObject withValues:dict];
            [newArray addObject:theObject];
        }
        
        [self.delegate retrievedEvents:newArray];
    }];
}

@end
