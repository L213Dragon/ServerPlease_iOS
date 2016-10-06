//
//  SettingViewController.m
//  SocialDining
//
//  Created by emil on 06/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize passwordTextField, confirmPasswordTextField, activityIndicator;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.changeBtn.layer.cornerRadius = 5;
    self.delBtn.layer.cornerRadius = 5;
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
- (IBAction)changeBtnPressed:(id)sender {
    if ([passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error." message:@"Password can not be empty!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    
    NSString *pass = passwordTextField.text;
    
    if ([pass length] < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Password must both be at least 6 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    
    
    if (![passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
        //Alert
        NSLog(@"Password does not match!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error." message:@"Password does not match!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        [self showProgressBar:@"Saving..."];
        [Comms changePassword:passwordTextField.text forDelegate:self];
    }
}

- (IBAction)deleteBtnPressed:(id)sender {
    
    [[PFUser currentUser] delete];
    [self clearNotification];
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)logoutBtnPressed:(id)sender {
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
            //[alert show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void) commsChangePasswordComplete:(BOOL)success{
    
    if (success) {
        NSLog(@"succeed changing password!");
        PFUser *user = [PFUser currentUser];
        [user setObject:[NSNumber numberWithInt:0] forKey:@"loggedIn"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                [[PFInstallation currentInstallation] setObject:[NSNumber numberWithInt:0] forKey:@"loggedin"];
                [[PFInstallation currentInstallation] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error) {
                        [PFUser logOutInBackground];
                        [self clearNotification];

                        [hud hide:YES];
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
    } else {

        [hud hide:YES];
        NSLog(@"failed changing password!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error." message:@"Failed changing password!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
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
