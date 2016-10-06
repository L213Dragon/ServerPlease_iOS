//
//  ChTblViewController.h
//  SocialDining
//
//  Created by emil on 05/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "ViewController.h"
#import "DataStore.h"
#import "Comms.h"
#import "MBProgressHUD.h"

@interface ChTblViewController : ViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate>
{
    NSMutableArray *othersNumbers;
    NSMutableArray *myNumbers;
    NSMutableArray *numbers;
    MBProgressHUD *hud;
    CLLocationManager *currentLocation;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *chRestBtn;

@end
