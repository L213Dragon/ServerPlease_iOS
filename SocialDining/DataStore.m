//
//  DataStore.m
//  SocialDining
//
//  Created by emil on 06/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

static DataStore *instance = nil;
+ (DataStore *) instance
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[DataStore alloc] init];
        }
    }
    
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        _waitersNumbers = [[NSMutableArray alloc] init];
        _waiterRestaurant = [[Restaurant alloc] init];
        _myNumbers = [[NSMutableArray alloc] init];
        _currentLocation = [[CLLocation alloc] init];
    }
    return self;
}

- (void) reset{
    
}


@end
