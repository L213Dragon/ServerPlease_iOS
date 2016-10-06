//
//  Utils.m
//  SocialDining
//
//  Created by devel on 7/21/16.
//  Copyright © 2016 emil. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void) showMessage:(NSString*)title message:(NSString*)message delete:(UIViewController*)controller{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:controller cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}





@end
