//
//  SelTblViewController.h
//  SocialDining
//
//  Created by emil on 05/01/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "ViewController.h"
#import "MapPoint.h"
#import "DataStore.h"
#import "Comms.h"
#import "Restaurant.h"

@interface SelTblViewController : ViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *myNumbers;
    NSMutableArray *otherNumbers;
    MBProgressHUD *hud;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *deselectAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
