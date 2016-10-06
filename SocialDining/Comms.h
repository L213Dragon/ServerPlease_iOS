//
//  Comms.h
//  SocialDining
//
//  Created by emil on 06/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "DataStore.h"

@protocol CommsDelegate <NSObject>
@optional

- (void) commsDidFBLogin:(BOOL)loggedIn;
- (void) commsGetWaitersHereComplete:(BOOL)success here:(NSMutableArray *)waitersHere;
- (void) commsSaveMyNumbersComplete:(BOOL)success;
- (void) commsSaveMyNumbersAndRestaurantComplete:(BOOL)success;
- (void) commsChangePasswordComplete:(BOOL)success;
- (void) commsCheckRestaurantAvailableComplete:(BOOL)success available:(BOOL)available;
- (void) commsCheckSeatAvailableComplete:(BOOL)success available:(BOOL)available chargedIn:(BOOL)charged;
- (void) commsSendPushNotificationComplete:(BOOL)success;
- (void) commsSaveRestaurantComplete:(BOOL)success;

@end



@interface Comms : NSObject

+ (void) fbLogin:(id<CommsDelegate>)delegate;
+ (void) getWaitersHere:(CLLocationCoordinate2D)coordinate forDelegate:(id<CommsDelegate>)delegate;
+ (void) saveMyNumbers:(NSMutableArray *)numbers forDelegate:(id<CommsDelegate>)delegate;
+ (void) saveMyNumbersAndRestaurant:(NSMutableArray *)numbers name:(NSString *)restaurantName location:(CLLocationCoordinate2D)coordinate forDelegate:(id<CommsDelegate>)delegate;
+ (void) changePassword:(NSString *)password forDelegate:(id<CommsDelegate>)delegate;
+ (void) checkRestaurantAvailable:(CLLocationCoordinate2D)coordinate forDelegate:(id<CommsDelegate>)delegate;
+ (void) checkSeatAvailable:(CLLocationCoordinate2D)coordinate number:(NSString *)number forDelegate:(id<CommsDelegate>)delegate;
+ (void) sendPushNotification:(CLLocationCoordinate2D)restaurantCoordinate number:(NSString *)number forDelegate:(id<CommsDelegate>)delegate;
+ (void) saveRestaurant:(CLLocationCoordinate2D)restaurantCoordinate restaurantName:(NSString *)name forDelegate:(id<CommsDelegate>)delegate;

@end
