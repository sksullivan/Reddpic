//
//  MainViewController.h
//  Reddpic
//
//  Created by Stephen on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "AppDelegate.h"

@interface MainViewController : UIViewController <UIImagePickerControllerDelegate, FlipsideViewControllerDelegate>
{
    UIImage *img;
    AppDelegate *appDelegate;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *changeImageBtn;
@property (nonatomic, retain) IBOutlet UILabel *sourceLbl;
@property (nonatomic, retain) IBOutlet UILabel *editLbl;
@property (nonatomic, retain) IBOutlet UIButton *editBtn;
@property (nonatomic, retain) NSString *uhString;

@end
