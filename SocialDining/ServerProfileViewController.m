//
//  ServerProfileViewController.m
//  SocialDining
//
//  Created by emil on 05/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "ServerProfileViewController.h"

@interface ServerProfileViewController ()

@end

@implementation ServerProfileViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
//    PFUser *user = [PFUser currentUser];
//    [user setObject:[NSNumber numberWithInt:0] forKey:@"loggedIn"];
//    // [user saveInBackground];
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (!error) {
//            [[PFInstallation currentInstallation] setObject:[NSNumber numberWithInt:0] forKey:@"loggedin"];
//            [[PFInstallation currentInstallation] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                if (!error) {
//                    [PFUser logOutInBackground];
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//
//                } else {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"Failed logging out!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//                    [alert show];
//                }
//            }];
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed." message:@"Failed logging out!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//            [alert show];
//        }
//    }];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice!" message:@"Please log out to go to the main page!" delegate:self cancelButtonTitle:@"OKay" otherButtonTitles:nil];
    [alert show];
}


-(void)showProgressBar:(NSString *)msg{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = msg;
}

@end



