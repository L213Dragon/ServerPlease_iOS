//
//  forgotPasswordViewController.m
//  SocialDining
//
//  Created by emil on 15/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "forgotPasswordViewController.h"

@interface forgotPasswordViewController ()

@end

@implementation forgotPasswordViewController

@synthesize emailTextfield;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.resetBtn.layer.cornerRadius = 5;
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

- (IBAction)resetPasswordBtnPressed:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground:emailTextfield.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Password." message:@"New password has been sent to your email." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    return ;
}

-(void)showProgressBar:(NSString *)msg{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = msg;
}


@end
