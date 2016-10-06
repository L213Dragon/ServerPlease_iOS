//
//  Comms.m
//  SocialDining
//
//  Created by emil on 06/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "Comms.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation Comms

+ (void) getWaitersHere:(CLLocationCoordinate2D)coordinate forDelegate:(id<CommsDelegate>)delegate{
    
    // Get the waiters in the restaurant
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFGeoPoint *geoPoint = [[PFGeoPoint alloc] init];
    [geoPoint setLatitude:coordinate.latitude];
    [geoPoint setLongitude:coordinate.longitude];
    [query whereKey:@"location" equalTo:geoPoint];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSMutableArray *waiters = [[NSMutableArray alloc] init];
            waiters = [objects mutableCopy];
            if ([delegate respondsToSelector:@selector(commsGetWaitersHereComplete:here:)]) {
                [delegate commsGetWaitersHereComplete:YES here:waiters];
            }
        } else {
            NSLog(@"Objects error: %@", error.localizedDescription);
            if ([delegate respondsToSelector:@selector(commsGetWaitersHereComplete:here:)]) {
                [delegate commsGetWaitersHereComplete:NO here:nil];
            }
        }
    }];
}

+ (void) saveMyNumbers:(NSMutableArray *)numbers forDelegate:(id<CommsDelegate>)delegate{
    
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:numbers forKey:@"table_numbers"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            if ([delegate respondsToSelector:@selector(commsSaveMyNumbersComplete:)]) {
                [delegate commsSaveMyNumbersComplete:YES];
            }
        } else {
            if ([delegate respondsToSelector:@selector(commsSaveMyNumbersComplete:)]) {
                [delegate commsSaveMyNumbersComplete:NO];
            }
        }
    }];
}


+ (void) saveMyNumbersAndRestaurant:(NSMutableArray *)numbers name:(NSString *)restaurantName location:(CLLocationCoordinate2D)coordinate forDelegate:(id<CommsDelegate>)delegate{
    
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:numbers forKey:@"table_numbers"];
    [currentUser setObject:restaurantName forKey:@"restaurant_name"];
    PFGeoPoint *geoPoint = [[PFGeoPoint alloc] init];
    [geoPoint setLatitude:coordinate.latitude];
    [geoPoint setLongitude:coordinate.longitude];
    [currentUser setObject:geoPoint forKey:@"location"];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            if ([delegate respondsToSelector:@selector(commsSaveMyNumbersAndRestaurantComplete:)]) {
                [delegate commsSaveMyNumbersAndRestaurantComplete:YES];
            }
        } else {
            if ([delegate respondsToSelector:@selector(commsSaveMyNumbersAndRestaurantComplete:)]) {
                [delegate commsSaveMyNumbersAndRestaurantComplete:NO];
            }
        }
    }];
}

+ (void) changePassword:(NSString *)password forDelegate:(id<CommsDelegate>)delegate{
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setPassword:password];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            if ([delegate respondsToSelector:@selector(commsSaveMyNumbersComplete:)]) {
                [delegate commsChangePasswordComplete:YES];
            }
        } else {
            if ([delegate respondsToSelector:@selector(commsSaveMyNumbersComplete:)]) {
                [delegate commsChangePasswordComplete:NO];
            }
        }
    }];
}

+ (void) checkRestaurantAvailable:(CLLocationCoordinate2D)coordinate forDelegate:(id<CommsDelegate>)delegate{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFGeoPoint *geoPoint = [[PFGeoPoint alloc] init];
    [geoPoint setLatitude:coordinate.latitude];
    [geoPoint setLongitude:coordinate.longitude];
    [query whereKey:@"location" equalTo:geoPoint];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSInteger count = [objects count];
            if (count > 0) {
                if ([delegate respondsToSelector:@selector(commsCheckRestaurantAvailableComplete:available:)]) {
                    [delegate commsCheckRestaurantAvailableComplete:YES available:YES];
                }
            } else {
                if ([delegate respondsToSelector:@selector(commsCheckRestaurantAvailableComplete:available:)]) {
                    [delegate commsCheckRestaurantAvailableComplete:YES available:NO];
                }
            }
        } else {
            if ([delegate respondsToSelector:@selector(commsCheckRestaurantAvailableComplete:available:)]) {
                [delegate commsCheckRestaurantAvailableComplete:NO available:NO];
            }
        }
    }];
}

+ (void) checkSeatAvailable:(CLLocationCoordinate2D)coordinate number:(NSString *)number forDelegate:(id<CommsDelegate>)delegate{
    PFGeoPoint *geoPoint = [[PFGeoPoint alloc] init];
    [geoPoint setLatitude:coordinate.latitude];
    [geoPoint setLongitude:coordinate.longitude];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"CallLog"];
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:-180];
    [query1 whereKey:@"location" equalTo:geoPoint];
    [query1 whereKey:@"table_number" equalTo:number];
    [query1 whereKey:@"createdAt" greaterThan:timeAgoDate];
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            if ([objects count] == 0) {
                PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                
                [query whereKey:@"location" equalTo:geoPoint];
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObject:number];
                [query whereKey:@"table_numbers" containedIn:arr];
                [query whereKey:@"loggedIn" equalTo:[NSNumber numberWithInt:1]];
                
                
                
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    if (!error) {
                        NSInteger count = [objects count];
                        if (count > 0) {
                            if ([delegate respondsToSelector:@selector(commsCheckSeatAvailableComplete:available:chargedIn:)]) {
                                [delegate commsCheckSeatAvailableComplete:YES available:YES chargedIn:NO];
                            }
                        } else {
                            if ([delegate respondsToSelector:@selector(commsCheckSeatAvailableComplete:available:chargedIn:)]) {
                                [delegate commsCheckSeatAvailableComplete:YES available:NO chargedIn:NO];
                            }
                        }
                    } else {
                        if ([delegate respondsToSelector:@selector(commsCheckSeatAvailableComplete:available:chargedIn:)]) {
                            [delegate commsCheckSeatAvailableComplete:NO available:NO chargedIn:NO];
                        }
                    }
                }];
            } else {
                if ([delegate respondsToSelector:@selector(commsCheckSeatAvailableComplete:available:chargedIn:)]) {
                    [delegate commsCheckSeatAvailableComplete:YES available:NO chargedIn:YES];
                }
            }
        } else {
            if ([delegate respondsToSelector:@selector(commsCheckSeatAvailableComplete:available:)]) {
                [delegate commsCheckSeatAvailableComplete:NO available:NO chargedIn:YES];
            }
        }
    }];
}

+ (void) sendPushNotification:(CLLocationCoordinate2D)restaurantCoordinate number:(NSString *)number forDelegate:(id<CommsDelegate>)delegate{
    PFGeoPoint *geoPoint = [[PFGeoPoint alloc] init];
    [geoPoint setLatitude:restaurantCoordinate.latitude];
    [geoPoint setLongitude:restaurantCoordinate.longitude];
    
    PFObject *obj = [PFObject objectWithClassName:@"CallLog"];
    [obj setObject:geoPoint forKey:@"location"];
    [obj setObject:number forKey:@"table_number"];
    [obj saveInBackground];
    
    // Get the user in charge of the restaurant-table_number
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    
    [query whereKey:@"location" equalTo:geoPoint];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:number];
    [query whereKey:@"table_numbers" containedIn:arr];
    [query whereKey:@"loggedIn" equalTo:[NSNumber numberWithInt:1]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (PFUser *user in objects) {
                NSString *email = [user objectForKey:@"username"];
                
                NSString *alert = [NSString stringWithFormat: @"Number %@ is calling service!",  number];
                
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                      email, @"email",
                                      alert, @"alert",
                                      [NSString stringWithFormat:@"ServerPlease!"], @"title",
                                      @"Increment", @"badge",
                                      number, @"table_number",
                                      @"default", @"sound", nil];
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];
                
                if (! jsonData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    [PFCloud callFunctionInBackground:@"sendPush"
                                       withParameters:@{@"data": jsonString,
                                                        @"email": email}
                                                block:^(NSArray *results, NSError *error) {
                                                    if (!error) {
                                                        // this is where you handle the results and change the UI.
                                                    } else {
                                                        NSLog(@"%@", error);
                                                    }
                                                }];
                }
            }
            
            if ([delegate respondsToSelector:@selector(commsSendPushNotificationComplete:)]) {
                [delegate commsSendPushNotificationComplete:YES];
            }
        } else {
            if ([delegate respondsToSelector:@selector(commsSendPushNotificationComplete:)]) {
                [delegate commsSendPushNotificationComplete:NO];
            }
        }
    }];
}

+ (void) saveRestaurant:(CLLocationCoordinate2D)restaurantCoordinate restaurantName:(NSString *)name forDelegate:(id<CommsDelegate>)delegate{
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:name forKey:@"restaurant_name"];
    PFGeoPoint *geoPoint = [[PFGeoPoint alloc] init];
    [geoPoint setLatitude:restaurantCoordinate.latitude];
    [geoPoint setLongitude:restaurantCoordinate.longitude];
    [currentUser setObject:geoPoint forKey:@"location"];
    NSMutableArray *empty_array = [[NSMutableArray alloc] init];
    [currentUser setObject:empty_array forKey:@"table_numbers"];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            if ([delegate respondsToSelector:@selector(commsSaveRestaurantComplete:)]) {
                [delegate commsSaveRestaurantComplete:YES];
            }
        } else {
            if ([delegate respondsToSelector:@selector(commsSaveRestaurantComplete:)]) {
                [delegate commsSaveRestaurantComplete:NO];
            }
        }
    }];
}

+ (void)fbLogin:(id<CommsDelegate>)delegate{
    NSArray *permissionsArray = @[@"public_profile", @"email"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error){
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                NSLog(@"An error occurred %@", error.localizedDescription);
            }
            
            // Callback - login failed
            if ([delegate respondsToSelector:@selector(commsDidFBLogin:)]) {
                [delegate commsDidFBLogin:NO];
            }
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook");
            } else {
                NSLog(@"User logged in through Facebook!");
            }
            
            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
            [parameters setValue:@"email, name" forKey:@"fields"];
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result, NSError *error) {
                if (!error) {
                    NSMutableDictionary *userData = [(NSDictionary *)result mutableCopy];
                    //Store the Facebook Id
                    NSString *email = [userData objectForKey:@"email"];
//                    [[PFUser currentUser] setObject:email forKey:@"username"];
                    [[PFUser currentUser] setObject:email forKey:@"email"];
                    [[PFUser currentUser] saveInBackground];
                    if ([delegate respondsToSelector:@selector(commsDidFBLogin:)]) {
                        NSLog(@"currentuser saved successfully!");
                        [delegate commsDidFBLogin:YES];
                    }
                    
                }
            }];
        }
    }];
}







@end
