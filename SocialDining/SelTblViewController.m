//
//  SelTblViewController.m
//  SocialDining
//
//  Created by emil on 05/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "SelTblViewController.h"

@interface SelTblViewController ()
{
    NSMutableArray *numbers;
}

@end

@implementation SelTblViewController

@synthesize activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.selectAllBtn.layer.cornerRadius = 5;
    self.deselectAllBtn.layer.cornerRadius = 5;
    self.saveBtn.layer.cornerRadius = 5;
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
    
    numbers = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 101; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d", i];
        [numbers addObject:str];
    }
    
    myNumbers = [[NSMutableArray alloc] init];
    otherNumbers = [[NSMutableArray alloc] init];
    
    otherNumbers = [[DataStore instance].waitersNumbers mutableCopy];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
    
    UIButton *numberButton = (UIButton *)[cell viewWithTag:100];
    [numberButton setTitle:[numbers objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [numberButton setBackgroundImage:[UIImage imageNamed:@"btn_grey.jpg"] forState:UIControlStateNormal];
    NSString *currentNumber = [numbers objectAtIndex:indexPath.row];
    
    BOOL flag = NO;
    for (NSString *otherNumber in otherNumbers) {
        
        if ([otherNumber isEqualToString:currentNumber]) {
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Select the cell");
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Deselect the cell");
}


- (IBAction)numberBtnPressed:(id)sender {
    NSString *number = [sender titleLabel].text;
    NSLog(@"Clicked number: %@", number);
    
    // Check if clicked number is in the mynumbers
    BOOL flag = NO;
    
    for (NSString *myNumber in myNumbers) {
        if ([number isEqualToString:myNumber]) {
            [myNumbers removeObject:number];
            flag = YES; // number has already been in myNumbers
            // [sender setBackgroundColor:[UIColor lightGrayColor]];
            
            BOOL flag1 = NO;
            for ( NSString *oNumber in otherNumbers) {
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
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_green.jpg"] forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)saveBtnPressed:(id)sender {
    
    // Save the myNumbers to _User table

    [self showProgressBar:@"Saving..."];
    Restaurant *restaurant = [DataStore instance].waiterRestaurant;
    NSString *name = [restaurant getName];
    CLLocationCoordinate2D coordinate = [restaurant getCoordinate];
    [Comms saveMyNumbersAndRestaurant:myNumbers name:name location:coordinate forDelegate:self];
}

- (void) commsSaveMyNumbersAndRestaurantComplete:(BOOL)success{

    [hud hide:YES];
    if (success) {
        NSLog(@"Succeed saving table numbers");
        // save the myNumbers to datastore
        [DataStore instance].myNumbers = myNumbers;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Saved table numbers successfully!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        
        [self performSegueWithIdentifier:@"gotoProfile" sender:self];
    } else {
        NSLog(@"Failed saving table numbers");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed saving." message:@"Failed saving table numbers." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
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


-(void)showProgressBar:(NSString *)msg{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = msg;
}

@end
