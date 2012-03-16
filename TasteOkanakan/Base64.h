//
//  Base64.h
//  Taste Okanagan
//
//  Created by Stephen Visser on 12-03-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Base64 : NSObject

+ (NSData *)decodeBase64WithString:(NSString *)strBase64 ;
@end
