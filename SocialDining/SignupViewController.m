//
//  SignupViewController.m
//  SocialDining
//
//  Created by emil on 04/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "SignupViewController.h"


@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize usernameEntry, emailEntry, passwordEntry, activityIndicator, confirmPasswordEntry;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.signupBtn.layer.cornerRadius = 5;
    
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
- (IBAction)signupBtnPressed:(id)sender {
    

    NSString *pass = [passwordEntry text];
    NSString *email = [emailEntry text];
    if ([email length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Email can not be empty." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    
    if ([pass length] < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Password must be at least 6 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    
    if ([email length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter your email address." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        
        return ;
    }
    
    if (![pass isEqualToString: confirmPasswordEntry.text]) {
        [Utils showMessage:@"Alert" message:@"Password does not match!" delete:self];
        return ;
    }
    
    
    [self showProgressBar:@"Signup..."];
    
    
        PFUser *newUser = [PFUser user];
        newUser.username = email;
        newUser.password = pass;
        newUser.email = email;
        [newUser setObject:[NSNumber numberWithInt:1] forKey:@"loggedIn"];
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [hud hide:YES];
            if (error) {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];

                [hud hide:YES];
            } else {
                [PFInstallation currentInstallation][@"email"] = email;
                [PFInstallation currentInstallation][@"loggedin"] = [NSNumber numberWithInt:1];
                [[PFInstallation currentInstallation] saveInBackground];
                [self performSegueWithIdentifier:@"signupToMain" sender:self];

                [hud hide:YES];
            }
        }];
    //    }

}

-(void)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showProgressBar:(NSString *)msg{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = msg;
}

@end
