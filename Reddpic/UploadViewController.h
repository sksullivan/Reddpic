//
//  UploadViewController.h
//  Reddpic
//
//  Created by Stephen on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ImgurUploader.h"
#import "SBJson.h"
#import "NSString+URLEscape.h"

@interface UploadViewController : UIViewController <ImgurUploaderDelegate>
{
    AppDelegate *appDelegate;
    UITextField *titleFld;
    UITextField *srFld;
}

@property (nonatomic, retain) IBOutlet UIButton *submitBtn;
@property (nonatomic, retain) IBOutlet UITextField *titleFld;
@property (nonatomic, retain) IBOutlet UITextField *srFld;
@property (nonatomic, retain) IBOutlet UIImageView *uploadImageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain) NSString *imgurURLString;

- (IBAction)uploadSelectedPhoto:(id)sender;

@end
