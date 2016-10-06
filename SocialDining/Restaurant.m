//
//  Restaurant.m
//  SocialDining
//
//  Created by emil on 06/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

-(NSString *)getName{
    return name;
}

-(NSString *)getAddress{
    return address;

}

-(CLLocationCoordinate2D)getCoordinate{
    return coordinate;
}

-(void)setName:(NSString *)arg_name{
    name = arg_name;
}

-(void)setAddress:(NSString *)arg_address{
    address = arg_address;
}

-(void)setCoordiname:(CLLocationCoordinate2D)arg_coordinate{
    coordinate = arg_coordinate;
}

@end

