//
//  forgotPasswordViewController.h
//  SocialDining
//
//  Created by emil on 15/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface forgotPasswordViewController : UIViewController{
    MBProgressHUD *hud;
}

@property (strong, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end
