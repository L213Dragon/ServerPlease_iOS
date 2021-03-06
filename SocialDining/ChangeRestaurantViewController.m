//
//  ChangeRestaurantViewController.m
//  SocialDining
//
//  Created by emil on 13/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "ChangeRestaurantViewController.h"

@interface ChangeRestaurantViewController ()

@end

@implementation ChangeRestaurantViewController

@synthesize mapView;
@synthesize userHeadingBtn;
@synthesize activityIndicator, titleLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    restaurantSelected = NO;
    calledGoogleApi = NO;
    
    self.saveBtn.layer.cornerRadius = 5;
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
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    
    UIImage *buttonArrow = [UIImage imageNamed:@"LocationBlue.png"];
    [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *restaurantName = [currentUser objectForKey:@"restaurant_name"];
    titleLabel.text = [NSString stringWithFormat:@"You are serving at %@.", restaurantName];
    
    [self showProgressBar:@"Finding restaurants..."];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //create image instance add here back image
    UIImage *imgBack = [UIImage imageNamed:@"btn_empty.png"];
    //create UIButton instance for UIBarButtonItem
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:imgBack forState:UIControlStateNormal];
    btnBack.frame = CGRectMake(0, 0, 15,25);
    [btnBack addTarget:self action:@selector(btnBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //create UIBarButtonItem instance
    UIBarButtonItem *barBtnBackItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    //set in UINavigationItem
    self.navigationItem.leftBarButtonItem = barBtnBackItem;
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        CLLocation *location = [DataStore instance].currentLocation;
        [self queryGooglePlaces1:@"restaurant" currentLocation:location];
    }
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
            [hud hide: YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice!" message:@"Can not find nearby restaurants." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    });
}


-(void) queryGooglePlaces: (NSString *) googleType
{
    
    
    // Build the url string we are going to sent to Google. NOTE: The kGOOGLE_API_KEY is a constant which should contain your own API key that you can obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%d&types=%@&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude, RESTAURANT_SEARCH_RADIUS, googleType, kGOOGLE_API_KEY];
    
    //Formulate the string as URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        if (data != nil) {
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        } else {
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
    for (id<MKAnnotation> annotation in mapView.annotations)
    {
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [mapView removeAnnotation:annotation];
        }
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
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        //Create a new annotiation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:nil coordinate:placeCoord];
        
        
        [mapView addAnnotation:placeObject];
    }
    

    [hud hide:YES];
    
}



- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - MKMapViewDelegate methods.




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
        }        annotationView.enabled = YES;
        
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    NSLog(@"Region did changed!");
    
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set our current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    currenDist = 1000;
    
    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
    
    launchTime ++;
    if (launchTime == 3) {

    }

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    // Set the restaurant name in the title label on the screen.
    MapPoint *annotation = view.annotation;
    titleLabel.text = [NSString stringWithFormat:@"You are serving at the %@.", annotation.name];
    
    restaurantSelected = YES;
    
    restaurantLocation = annotation.coordinate;
    
    // Save the resaurant data into the datastore
    [[DataStore instance].waiterRestaurant setName:annotation.name];
    [[DataStore instance].waiterRestaurant setAddress:annotation.address];
    [[DataStore instance].waiterRestaurant setCoordiname:annotation.coordinate];
    
}

-(void)btnBackAction:(id)sender
{

    [hud hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)zoomIn:(id)sender {
    MKCoordinateRegion region = self.mapView.region;
    region.span.latitudeDelta /= 2.0;
    region.span.longitudeDelta /= 2.0;
    self.mapView.region = region;
}

- (IBAction)zoomOut:(id)sender {
    MKCoordinateRegion region = self.mapView.region;
    region.span.latitudeDelta *= 2.0;
    region.span.longitudeDelta *= 2.0;
    self.mapView.region = region;
}

#pragma mark User Heading
- (IBAction) startShowingUserHeading:(id)sender{
    
    if(self.mapView.userTrackingMode == 0){
        [self.mapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
        
        //Turn on the position arrow
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationBlue.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
        
    }
    else if(self.mapView.userTrackingMode == 1){
        [self.mapView setUserTrackingMode: MKUserTrackingModeFollowWithHeading animated: YES];
        
        //Change it to heading angle
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationHeadingBlue"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    else if(self.mapView.userTrackingMode == 2){
        [self.mapView setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    
    
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated{
    if(self.mapView.userTrackingMode == 0){
        [self.mapView setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    
}

- (IBAction)saveBtnPressed:(id)sender {
    
    if (restaurantSelected == NO) {
        [Utils showMessage:@"Alert" message:@"Please select restaurant" delete:self];
        return ;
    }
    
    
    [self showProgressBar:@"Saving..."];
    CLLocationCoordinate2D coordinate = [[DataStore instance].waiterRestaurant getCoordinate];
    NSString *restaurant_name = [[DataStore instance].waiterRestaurant getName];
    [Comms saveRestaurant:coordinate restaurantName:restaurant_name forDelegate:self];
}

- (void) commsSaveRestaurantComplete:(BOOL)success{

    [hud hide:YES];
    if (success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved successfully." message:@"Saved the restaurant successfully." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [self clearNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changedRestaurant" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"Failed saving the restaurant." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)findRestaurant:(id)sender {

    [self showProgressBar:@"Finding restaurants..."];
    [self queryGooglePlaces:@"restaurant"];
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
