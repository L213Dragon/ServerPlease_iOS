//
//  SignupViewController.h
//  SocialDining
//
//  Created by emil on 04/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface SignupViewController : ViewController
{
    
     MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITextField *emailEntry;
@property (weak, nonatomic) IBOutlet UITextField *usernameEntry;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntry;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordEntry;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;

@end
