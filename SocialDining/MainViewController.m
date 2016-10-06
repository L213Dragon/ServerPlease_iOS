//
//  MainViewController.m
//  SocialDining
//
//  Created by emil on 04/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    NSMutableArray *myNumbers;
}
@end

@implementation MainViewController

@synthesize activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.diningBtn.layer.cornerRadius = 5;
    self.waiterBtn.layer.cornerRadius = 5;
    NSLog(@"%lu", (unsigned long)[[DataStore instance].myNumbers count]);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager requestAlwaysAuthorization];
    
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)witerBtnPressed:(id)sender {
    
    if ([PFUser currentUser] !=nil) {
        // Check for restaurant_name
        NSString *restaurant_name = [[PFUser currentUser] objectForKey:@"restaurant_name"];
        if (restaurant_name == nil || [restaurant_name  isEqual: @""]) {
            [self performSegueWithIdentifier:@"gotoSelRestaurant" sender:self];
        } else {
            // Get the waitersNumbers and myNumbers from _User table
            PFUser *currentUser = [PFUser currentUser];
            
            // Get the my table numbers
            NSLog(@"%lu", (unsigned long)[[DataStore instance].myNumbers count]);
            [DataStore instance].myNumbers = [[currentUser objectForKey:@"table_numbers"] mutableCopy];
            NSLog(@"%lu", (unsigned long)[[DataStore instance].myNumbers count]);
            [self checkUserInRestaurant];
        }
    } else {
        [self performSegueWithIdentifier:@"gotoLogin" sender:self];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    NSLog(@"did update user location");
    NSLog(@"new location: %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    NSLog(@"old location: %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);

    [DataStore instance].currentLocation = newLocation;
}

-(void) checkUserInRestaurant {
    PFUser *currentUser = [PFUser currentUser];
    PFGeoPoint *geoPoint = [currentUser objectForKey:@"location"];
    
    CLLocation *locSaved = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
    CLLocation *locCur = [DataStore instance].currentLocation;
    
    CLLocationDistance currentDistance = [locCur distanceFromLocation:locSaved];
    if (currentDistance > RANGE_OF_RESTAURANT) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert." message:@"You are not in your restaurant. Please login in your restaurant." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        
        
        // Log Off
        PFUser *user = [PFUser currentUser];
        [user setObject:[NSNumber numberWithInt:0] forKey:@"loggedIn"];
        NSMutableArray *tableNumbers = [[NSMutableArray alloc] init];
        [user setObject:tableNumbers forKey:@"table_numbers"];
        [user setObject:@"" forKey:@"restaurant_name"];
        

        [self showProgressBar:@"Loading..."];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                
                [[PFInstallation currentInstallation] setObject:[NSNumber numberWithInt:0] forKey:@"loggedin"];
                [[PFInstallation currentInstallation] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error) {
                        [PFUser logOutInBackground];
                        [self clearNotification];

                        
                        [hud hide:YES];
                    } else {

                        [hud hide:YES];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"Failed logging out!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        [alert show];
                    }
                }];
            } else {

                [hud hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"Failed logging out!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
        
    } else {
        [self performSegueWithIdentifier:@"gotoProfile" sender:self];
    }

}

-(void)showProgressBar:(NSString *)msg{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = msg;
}

-(void)clearNotification{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *empty_dic = [[NSMutableArray alloc] init];
    [defaults setObject:empty_dic forKey:@"notification"];
    // send local notification to clear the notification tables
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CLEAR_TABLE object:nil];
}

@end
