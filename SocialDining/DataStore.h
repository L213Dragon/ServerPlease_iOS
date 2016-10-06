//
//  DataStore.h
//  SocialDining
//
//  Created by emil on 06/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface DataStore : NSObject

+ (DataStore *) instance;
- (void) reset;

@property (strong, nonatomic)NSNumber *a;
@property (strong, nonatomic)NSMutableArray *waitersNumbers;
@property (strong, nonatomic)Restaurant *waiterRestaurant;
@property (strong, nonatomic)NSMutableArray *myNumbers;
@property (strong, nonatomic)CLLocation *currentLocation;

@end


