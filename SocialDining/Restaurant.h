//
//  Restaurant.h
//  SocialDining
//
//  Created by emil on 06/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Restaurant : NSObject
{
    NSString *name;
    NSString *address;
    CLLocationCoordinate2D coordinate;
}

-(NSString *)getName;
-(NSString *)getAddress;
-(CLLocationCoordinate2D)getCoordinate;

-(void)setName:(NSString *)arg_name;
-(void)setAddress:(NSString *)arg_address;
-(void)setCoordiname:(CLLocationCoordinate2D)arg_coordinate;

@end
