//
//  CallServiceViewController.h
//  SocialDining
//
//  Created by emil on 04/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Comms.h"
#import "Utils.h"
#import "DataStore.h"
#import "MapPoint.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define kGOOGLE_API_KEY @"AIzaSyD8oay_EkrzLaifDCCrNZ4cL6KGqwwojhQ"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface CallServiceViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    int launchTime;
    NSString *restaurantName;
    CLLocationCoordinate2D restaurantLocation;
    NSString *tb_number;
    CLLocationCoordinate2D currentCentre;
    CLLocationCoordinate2D currentLocation;
    int currenDist;
    MBProgressHUD *hud;
    BOOL initFlag;
    BOOL calledGoogleApi;
    
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong) NSMutableArray *annotations;
@property (strong, nonatomic) IBOutlet UIButton *userHeadingBtn;
@property (weak, nonatomic) IBOutlet UIButton *callServiceBtn;

@end
