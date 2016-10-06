//
//  MainViewController.h
//  SocialDining
//
//  Created by emil on 04/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DataStore.h"
#import "Comms.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    MBProgressHUD *hud;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *diningBtn;
@property (weak, nonatomic) IBOutlet UIButton *waiterBtn;

@end
