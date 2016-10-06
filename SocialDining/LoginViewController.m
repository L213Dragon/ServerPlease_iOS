//
//  LoginViewController.m
//  SocialDining
//
//  Created by emil on 04/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameEntry, passwordEntry, activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginBtn.layer.cornerRadius = 5;
    
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

- (IBAction)loginBtnPressed:(id)sender {
    NSString *user = [usernameEntry text];
    NSString *pass = [passwordEntry text];
    
    if ([user length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter email address." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return ;
    }
        [self showProgressBar:@"Logging in..."];
        [PFUser logInWithUsernameInBackground:user password:pass block:^(PFUser *user, NSError *error) {
            if (user) {
                NSNumber *loggedIn = [user objectForKey:@"loggedIn"];
                if ([loggedIn intValue] == 1) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"You have already logged in on the other device!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [PFUser logOutInBackground];
                    [hud hide:YES];
                    [self clearNotification];

                    return ;
                }
                
                [user setObject:[NSNumber numberWithInt:1] forKey:@"loggedIn"];
                [user saveInBackground];
                
                [PFInstallation currentInstallation][@"email"] = [usernameEntry text];
                [PFInstallation currentInstallation][@"loggedin"] = [NSNumber numberWithInt:1];
                [[PFInstallation currentInstallation] saveInBackground];
                [self performSegueWithIdentifier:@"gotoSelRestaurant1" sender:self];
            } else {

                [hud hide:YES];
                NSLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"Invalid Username and/or Password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
//    }

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

- (IBAction)fbLoginBtnTapped:(id)sender {
    [self showProgressBar:@"Loggin in..."];
    [Comms fbLogin:self];
}

-(void)commsDidFBLogin:(BOOL)loggedIn{
    [hud hide:YES];
    if (loggedIn) {
        NSLog(@"Succeed facebook login!");
        PFUser *user = [PFUser currentUser];
        NSNumber *loggedIn = [user objectForKey:@"loggedIn"];
        if ([loggedIn intValue] == 1) {            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"You have already logged in on the other device!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [PFUser logOutInBackground];
            [hud hide:YES];
            [self clearNotification];
            return ;
        }
        
        [user setObject:[NSNumber numberWithInt:1] forKey:@"loggedIn"];
        [user saveInBackground];
        
        [PFInstallation currentInstallation][@"email"] = [user objectForKey:@"username"];
        [PFInstallation currentInstallation][@"loggedin"] = [NSNumber numberWithInt:1];
        [[PFInstallation currentInstallation] saveInBackground];
        [self performSegueWithIdentifier:@"gotoSelRestaurant1" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Failed ." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}



@end
