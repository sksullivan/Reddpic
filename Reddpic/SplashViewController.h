//
//  SplashViewController.h
//  Reddpic
//
//  Created by Stephen on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SplashViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    BOOL picked;
}

@property (nonatomic, retain) IBOutlet UIButton *libraryBtn;
@property (nonatomic, retain) IBOutlet UIButton *cameraBtn;
@property (nonatomic, retain) IBOutlet UIImageView *splashView;

- (void)pickMedia:(id)sender;

@end
