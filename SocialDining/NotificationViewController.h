//
//  NotificationViewController.h
//  SocialDining
//
//  Created by emil on 13/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "ViewController.h"

@interface NotificationViewController : ViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *tableNumbers;
}

@property (strong, nonatomic) IBOutlet UILabel *noRequestLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (strong, nonatomic) IBOutlet UITableView *notificationTableView;

@end
