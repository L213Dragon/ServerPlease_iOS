//
//  ChTblViewController.m
//  SocialDining
//
//  Created by emil on 05/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "ChTblViewController.h"

@interface ChTblViewController ()


@end

@implementation ChTblViewController

@synthesize activityIndicator, titleLabel;



- (void)viewDidLoad {
    [super viewDidLoad];
    numbers = [[NSMutableArray alloc] init];

    self.saveBtn.layer.cornerRadius = 5;
    self.chRestBtn.layer.cornerRadius = 5;
    
    for (int i = 1; i < 101; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d", i];
        [numbers addObject:str];
    }
    
    myNumbers = [[NSMutableArray alloc] init];
    
    othersNumbers = [[NSMutableArray alloc] init];
    myNumbers = [[DataStore instance].myNumbers mutableCopy];
    
    
    // Get the waitersNumbers and myNumbers from _User table
    PFUser *currentUser = [PFUser currentUser];
    PFGeoPoint *geoPoint = [currentUser objectForKey:@"location"];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = geoPoint.latitude;
    coordinate.longitude = geoPoint.longitude;
    
    NSString *restaurantName = [[PFUser currentUser] objectForKey:@"restaurant_name"];
    titleLabel.text = [NSString stringWithFormat:@"You are serving at %@", restaurantName];
    titleLabel.adjustsFontSizeToFitWidth=YES;
    titleLabel.minimumScaleFactor=0.5;
    
    [self setNotificationManager];
    
    currentLocation = [[CLLocationManager alloc]init];
    currentLocation.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    currentLocation.delegate = self;
    [currentLocation startUpdatingLocation];


    [self showProgressBar:@"Loading..."];
    [Comms getWaitersHere:coordinate forDelegate:self];
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

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    NSLog(@"did update user location");
    
    PFGeoPoint *geoPoint = [[PFUser currentUser] objectForKey:@"location"];

    CLLocation *restaurantLocation = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
    
    CLLocationDistance distance = [newLocation distanceFromLocation:restaurantLocation];
    
    if (distance > RANGE_OF_RESTAURANT ) {
        // Log off
        PFUser *user = [PFUser currentUser];
        [user setObject:[NSNumber numberWithInt:0] forKey:@"loggedIn"];
        NSMutableArray *tableNumbers = [[NSMutableArray alloc] init];
        [user setObject:tableNumbers forKey:@"table_numbers"];
        [user setObject:@"" forKey:@"restaurant_name"];
        

        [self showProgressBar:@"Logging out..."];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                
                [[PFInstallation currentInstallation] setObject:[NSNumber numberWithInt:0] forKey:@"loggedin"];
                [[PFInstallation currentInstallation] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error) {
                        [PFUser logOutInBackground];

                        [hud hide:YES];
                        [self clearNotification];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {

                        [hud hide:YES];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"Failed logging out!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        [alert show];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            } else {

                [hud hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"Failed logging out!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        return ;
    }
}

- (void) setNotificationManager {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification) name:@"changedRestaurant" object:nil];
}

-(void)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [numbers count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
    
    UIButton *numberButton = (UIButton *)[cell viewWithTag:100];
    [numberButton setTitle:[numbers objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [numberButton setBackgroundImage:[UIImage imageNamed:@"btn_grey.jpg"] forState:UIControlStateNormal];
    
    // Set the other number color to red
    BOOL flag = NO;
    NSString *currentNumber = [numbers objectAtIndex:indexPath.row];
    for (NSString *oNumber in othersNumbers) {
        if ([oNumber isEqualToString:currentNumber]) {
            flag = YES;
            break;
        }
    }
    
    if (flag) {
        // [numberButton setBackgroundColor:[UIColor redColor]];
        [numberButton setBackgroundImage:[UIImage imageNamed:@"btn_red.jpg"] forState:UIControlStateNormal];
    }
    
    // Set the other number color to red
    flag = NO;
    for (NSString *mNumber in myNumbers) {
         if ([mNumber isEqualToString:currentNumber]) {
             flag = YES;
             break;
         }
    }
    
    if (flag) {
        // [numberButton setBackgroundColor:[UIColor greenColor]];
        [numberButton setBackgroundImage:[UIImage imageNamed:@"btn_green.jpg"] forState:UIControlStateNormal];
    } 
    
    return cell;
}


- (IBAction)numberBtnPressed:(id)sender {
    NSString *number = [sender titleLabel].text;
    NSLog(@"Clicked number: %@", number);
    NSInteger index = [number integerValue];
    
    
    // Check it is of others.
//    for (NSString *oNumber in othersNumbers) {
//        if ([number isEqualToString:oNumber]) {
//            NSLog(@"This number has already been covered by others");
//            return ;
//        }
//    }
    
    
    // Check if clicked number is in the mynumbers
    BOOL flag = NO;
    for (NSString *myNumber in myNumbers) {
        if ([number isEqualToString:myNumber]) {
            [myNumbers removeObject:number];
            flag = YES; // number has already been in myNumbers
            
            BOOL flag1 = NO;
            for ( NSString *oNumber in othersNumbers) {
                if ([oNumber isEqualToString:number]) {
                    [sender setBackgroundImage:[UIImage imageNamed:@"btn_red.jpg"] forState:UIControlStateNormal];
                    flag1 = YES;
                    break;
                }
            }
            
            if (flag1 == NO) {
                [sender setBackgroundImage:[UIImage imageNamed:@"btn_grey.jpg"] forState:UIControlStateNormal];
                break;
            }
            break;
        }
    }
    
    if (flag == NO) {
        [myNumbers addObject:number];
        // [sender setBackgroundColor:[UIColor greenColor]];
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_green.jpg"] forState:UIControlStateNormal];
    }    
}

- (IBAction)saveBtnPressed:(id)sender {
    // Save the myNumbers to _User table

    [self showProgressBar:@"Saving..."];
    [[DataStore instance].myNumbers removeAllObjects];
    [DataStore instance].myNumbers = [myNumbers mutableCopy];
    [Comms saveMyNumbers:myNumbers forDelegate:self];
}

- (void) commsSaveMyNumbersComplete:(BOOL)success{

    [hud hide:YES];
    if (success) {
        NSLog(@"Succeed saving table numbers");
        // saved the myNumbers to datastore
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Saved table numbers successfuly!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        PFUser *currentUser = [PFUser currentUser];
        NSString *restaurantName = [[PFUser currentUser] objectForKey:@"restaurant_name"];
        titleLabel.text = [NSString stringWithFormat:@"You are serving at %@", restaurantName];
    } else {
        NSLog(@"Failed saving table numbers");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"Failed saving table numbers." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];

    }
}

- (void) commsGetWaitersHereComplete:(BOOL)success here:(NSMutableArray *)waitersHere{

    if (success) {
        NSLog(@"succeed getting waiters in this restaurant");


        [hud hide:YES];
        
        [othersNumbers removeAllObjects];

        // Get the table numbers of waiters
        for (PFObject *waiter in waitersHere) {
            PFUser *currentUSer = [PFUser currentUser];
            NSString *emailOfCurrentUser = [currentUSer objectForKey:@"email"];
            NSString *emailOfWaiter = [waiter objectForKey:@"email"];
            if ([emailOfCurrentUser isEqualToString:emailOfWaiter]) {
                continue;
            }
            
            NSArray *tmpList = [waiter objectForKey:@"table_numbers"];
            int flag1 = 0;
            for (NSString *number1 in tmpList) {
                for (NSString *number2 in othersNumbers) {
                    if ([number1 isEqualToString:number2]) {
                        flag1 = 1;
                        break;
                    }
                }
                
                if (flag1 == 0) {
                    [othersNumbers addObject:number1];
                } else {
                    flag1 = 0;
                }
            }
        }
        
        [self.collectionView reloadData];

    } else {
        NSLog(@"failed getting waiters in this restaurant");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"Failed getting waiters in this restaurant." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)deselectBtnTapped:(id)sender {
    [myNumbers removeAllObjects];
    
    [self.collectionView reloadData];
}


- (IBAction)selectAllBtnTapped:(id)sender {
    [myNumbers removeAllObjects];
    for (int i=0; i<101; i++) {
        [myNumbers addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    [self.collectionView reloadData];
}

-(void) handleNotification{
    // Get the waitersNumbers and myNumbers from _User table
    [othersNumbers removeAllObjects];
    [myNumbers removeAllObjects];
    PFUser *currentUser = [PFUser currentUser];
    PFGeoPoint *geoPoint = [currentUser objectForKey:@"location"];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = geoPoint.latitude;
    coordinate.longitude = geoPoint.longitude;
    
    NSString *restaurantName = [[PFUser currentUser] objectForKey:@"restaurant_name"];
    titleLabel.text = [NSString stringWithFormat:@"You are serving at %@. Please select the tables.", restaurantName];
    titleLabel.adjustsFontSizeToFitWidth=YES;
    titleLabel.minimumScaleFactor=0.5;
    
    [self setNotificationManager];
    

    
    [Comms getWaitersHere:coordinate forDelegate:self];
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
