//
//  SelRestauViewController.h
//  SocialDining
//
//  Created by emil on 05/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"
#import "DataStore.h"
#import "Comms.h"
#import "MBProgressHUD.h"

#define kGOOGLE_API_KEY @"AIzaSyD8oay_EkrzLaifDCCrNZ4cL6KGqwwojhQ"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface SelRestauViewController : ViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    BOOL firstLaunch;
    int launchTime;
    CLLocationCoordinate2D restaurantLocation;
    int flag;
    MBProgressHUD *hud;
    int restaurantSelected;
    BOOL calledGoogleApi;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL alreadySetZoomScale;
@property (strong, nonatomic) IBOutlet UIButton *userHeadingBtn;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@end
