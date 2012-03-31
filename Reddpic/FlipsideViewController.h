//
//  FlipsideViewController.h
//  Reddpic
//
//  Created by Stephen on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SBJson.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController
{
    UIImageView *editImageView;
    NSMutableDictionary *cookieDict;
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *userFld;
@property (nonatomic, retain) IBOutlet UITextField *passwordFld;
@property (nonatomic, retain) IBOutlet UIButton *loginBtn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;

- (IBAction)done:(id)sender;
- (IBAction)loginToReddit;

@end
