//
//  CallServiceViewController.m
//  SocialDining
//
//  Created by emil on 04/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "CallServiceViewController.h"
#import "Utils.h"


@interface CallServiceViewController ()

@end

@implementation CallServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    calledGoogleApi = NO;
    
    self.callServiceBtn.layer.cornerRadius = 5;
    //create image instance add here back image
    UIImage *imgBack = [UIImage imageNamed:@"btn_back.png"];
    
    //create UIButton instance for UIBarButtonItem
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:imgBack forState:UIControlStateNormal];
    btnBack.frame = CGRectMake(0, 0, 15,25);
    [btnBack addTarget:self action:@selector(btnBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //create UIBarButtonItem instance
    UIBarButtonItem *barBtnBackItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    //set in UINavigationItem
    self.navigationItem.leftBarButtonItem = barBtnBackItem;
    
     UIImage *buttonArrow = [UIImage imageNamed:@"LocationBlue.png"];
     [self.userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];

    
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    [self showProgressBar:@"Finding Restaurants..."];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    }

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    if (launchTime < 4) {
        [aMapView setRegion:region animated:YES];
        NSLog(@"google map called!");
        CLLocation *location = [DataStore instance].currentLocation;
        
        
        [self queryGooglePlaces1:@"restaurant" currentLocation:location];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set our current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    currenDist = 1000;
    
    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
    launchTime ++;
}


-(void) queryGooglePlaces1:(NSString *)googleType currentLocation:(CLLocation *)currloc
{
    
    if (calledGoogleApi == YES) {
        return ;
    }
    
    calledGoogleApi = YES;
    // Build the url string we are going to sent to Google. NOTE: The kGOOGLE_API_KEY is a constant which should contain your own API key that you can obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%d&types=%@&sensor=true&key=%@", currloc.coordinate.latitude, currloc.coordinate.longitude, RESTAURANT_SEARCH_RADIUS, googleType, kGOOGLE_API_KEY];
    
    //Formulate the string as URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        if (data != nil) {
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        } else {
            NSLog(@"can not find restaurants");
            [hud hide: YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice!" message:@"Can not find nearby restaurants." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    // NSLog(@"Google Data: %@", places);
    
    //Plot the data in the places array onto the map with the plotPostions method.
    [self plotPositions:places];
    
    
}

- (void)plotPositions:(NSArray *)data
{
    //Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in self.mapView.annotations)
    {
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    if ([data count] == 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"There is no restaurant around you!"];
        return;
    }
    
    //Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++)
    {
        
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        
        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        //Create a new annotiation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:nil coordinate:placeCoord];
        
        [self.mapView addAnnotation:placeObject];
    }

    [hud hide:YES];
}



- (void) showRestaurants {
    //Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in self.mapView.annotations)
    {
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [self.mapView removeAnnotation:annotation];
        }
    }

    
    // Local search for restaurants in current region
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"restaurant";
    request.region = self.mapView.region;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        // Handle results of search
        for (MKMapItem *item in response.mapItems)
        {
            //Create a new annotiation.
            MapPoint *placeObject = [[MapPoint alloc] initWithName:item.name address:[item.placemark.addressDictionary objectForKey:@"Street"] coordinate:item.placemark.coordinate];
            [self.mapView addAnnotation:placeObject];
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Define our reuse indentifier.
    static NSString *identifier = @"MapPoint";
    
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            // annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}

-(void)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    
    // Check the user is in the restaurant
    MapPoint *annotation = view.annotation;
    restaurantName = annotation.name;
    restaurantLocation = annotation.coordinate;
    
    NSLog(@"location: %f %f", restaurantLocation.latitude, restaurantLocation.longitude);
    
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:restaurantLocation.latitude longitude:restaurantLocation.longitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    if (distance > RANGE_OF_RESTAURANT   ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Don`t play." message:@"You are not in this restaurant." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    

    [self showProgressBar:@"Loading..."];
    
    [Comms checkRestaurantAvailable:restaurantLocation forDelegate:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation.latitude = newLocation.coordinate.latitude;
    currentLocation.longitude = newLocation.coordinate.longitude;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *table_number = [alertView textFieldAtIndex:0];
        tb_number = table_number.text;
        NSLog(@"%@", table_number.text);
        
        self.titleLabel.text = [NSString stringWithFormat:@"You are seated at %@ in the %@", table_number.text, restaurantName];
        
        
        
        // Check whethere waiter logges in for that table

        [self showProgressBar:@"Loading..."];
        [Comms checkSeatAvailable:restaurantLocation number:tb_number forDelegate:self];
    }
}

- (IBAction)zoomIn:(id)sender {
    
    MKCoordinateRegion region = self.mapView.region;
    region.span.latitudeDelta /= 1.5;
    region.span.longitudeDelta /= 1.5;
    self.mapView.region = region;
    
}

- (IBAction)zoomOut:(id)sender {;
    
    MKCoordinateRegion region = self.mapView.region;
    region.span.latitudeDelta *= 1.5;
    region.span.longitudeDelta *= 1.5;
    self.mapView.region = region;
    
}

- (IBAction) startShowingUserHeading:(id)sender{
    
    if(self.mapView.userTrackingMode == 0){
        [self.mapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
        
        //Turn on the position arrow
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationBlue.png"];
        [self.userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
        
    }
    else if(self.mapView.userTrackingMode == 1){
        [self.mapView setUserTrackingMode: MKUserTrackingModeFollowWithHeading animated: YES];
        
        //Change it to heading angle
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationHeadingBlue"];
        [self.userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    else if(self.mapView.userTrackingMode == 2){
        [self.mapView setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [self.userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated{
    if(self.mapView.userTrackingMode == 0){
        [self.mapView setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [self.userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
}

- (void) commsCheckRestaurantAvailableComplete:(BOOL)success available:(BOOL)available{

    [hud hide:YES];
    if (success) {
        NSLog(@"success checking");
        if (available) {
            // Show the table number input dialog
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Table Number" message:@"Enter your table number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alert textFieldAtIndex:0];
            assert(textField);
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [alert addButtonWithTitle:@"OK"];
            [alert show];
        } else {
            NSLog(@"This restaurant is not available");
            NSLog(@"failed checking");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No waiters!" message:@"No waiters with this app at this location.Please ask waiter to download and use the app!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            
        }
    } else {
        NSLog(@"failed checking");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed checking." message:@"Failed checking service availability." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        
    }
}

- (IBAction)callServiceBtnPressed:(id)sender {
    // Check this seat is available
    
    if (tb_number == nil) {
        [Utils showMessage:@"Error" message:@"Please Select table number" delete:self];
        return ;
    }
    
    [self showProgressBar:@"Calling..."];
    [Comms sendPushNotification:restaurantLocation number:tb_number forDelegate:self];
}

- (void) commsCheckSeatAvailableComplete:(BOOL)success available:(BOOL)available chargedIn:(BOOL)charged{
    
    if (success) {
        NSLog(@"success checking");
        if (available) {

            [hud hide:YES];

        } else {

            [hud hide:YES];
            
            NSString *msg = @"";
            if (charged) {
                msg = @"This table has already been charged by other! Please enter enother number";
            } else {
                msg = @"No waiters with this app at this location. Please ask waiter to download and use the app!";
            }
            
            // Show the table number input dialog
            UIAlertView *alert =[[UIAlertView alloc ] initWithTitle:@"Table Number" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alert textFieldAtIndex:0];
            assert(textField);
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [alert addButtonWithTitle:@"OK"];
            [alert show];
        }
    } else {

        [hud hide:YES];
        NSLog(@"failed checking");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No waiters!" message:@"No waiters with this app at this location. Please ask waiter to download and use the app!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) commsSendPushNotificationComplete:(BOOL)success{

    [hud hide:YES];
    if (success) {
        NSLog(@"success sending push notification");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"calling successful!." message:@"Your request has been sent successfully!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        NSLog(@"failed sending push notification");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Calling Failed!" message:@"Failed calling service." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}


-(void)showProgressBar:(NSString *)msg{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = msg;
}



@end
