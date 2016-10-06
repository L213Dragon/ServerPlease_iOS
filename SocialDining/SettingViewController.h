//
//  SettingViewController.h
//  SocialDining
//
//  Created by emil on 06/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "Comms.h"
#import "MBProgressHUD.h"

@interface SettingViewController : ViewController
{
    MBProgressHUD *hud;
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end
