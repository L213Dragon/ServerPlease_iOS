//
//  NotificationViewController.m
//  SocialDining
//
//  Created by emil on 13/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableNumbers = [[NSMutableArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    tableNumbers = [[defaults objectForKey:@"notification"] mutableCopy];
    self.clearBtn.layer.cornerRadius = 5;

   [self.noRequestLabel setHidden:YES];
    
    [self setNotificationManager];
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

- (void) setNotificationManager {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification) name:@"receivedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification1) name:NOTIFICATION_CLEAR_TABLE object:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return [frinedsData count];
    return [tableNumbers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *simpleTableIdentifier = @"NotificationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //Configure the cell
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    NSInteger index = indexPath.row;
    NSString *text = [NSString stringWithFormat:@"Number %@ is calling service!", [tableNumbers objectAtIndex:index] ];
    label.text = [NSString stringWithFormat:@"%@", text];
    return cell;
}

- (IBAction)clearBtnPressed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *empty_dic = [[NSMutableArray alloc] init];
    //[[defaults objectForKey:@"notification"] removeAllObjects];
    [defaults setObject:empty_dic forKey:@"notification"];
    [tableNumbers removeAllObjects];
    [self.notificationTableView reloadData];
}

-(void)receivedNotification{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    tableNumbers = [[defaults objectForKey:@"notification"] mutableCopy];
    
//    if ([tableNumbers count] > 0) {
//        [self.noRequestLabel setHidden:YES];
//        [self.notificationTableView setHidden:NO];
//        [self.clearBtn setHidden:NO];
//        [self.notificationTableView reloadData];
//    } else {
//        [self.noRequestLabel setHidden:NO];
//        [self.notificationTableView setHidden:YES];
//        [self.clearBtn setHidden:YES];
//    }
    
    [self.noRequestLabel setHidden:YES];
    [self.notificationTableView setHidden:NO];
    [self.clearBtn setHidden:NO];
    [self.notificationTableView reloadData];

}

-(void)receivedNotification1{
    [tableNumbers removeAllObjects];
    [self.noRequestLabel setHidden:YES];
    [self.notificationTableView setHidden:NO];
    [self.clearBtn setHidden:NO];
    [self.notificationTableView reloadData];
}



@end
