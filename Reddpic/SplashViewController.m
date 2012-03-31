//
//  SplashViewController.m
//  Reddpic
//
//  Created by Stephen on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"

@implementation SplashViewController

@synthesize libraryBtn, cameraBtn, splashView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    picked = NO;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [splashView setImage:[appDelegate globalSelectedImage]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"has_logged_in"];
    BOOL hasLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"has_logged_in"];
    if (!hasLoggedIn) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reddpic" 
                                                        message:@"Do you mind Logging in to Reddit? To post images without a Reddit account, you will need to fill out CAPTCHAs."
                                                       delegate:self 
                                              cancelButtonTitle:@"No Thanks"
                                              otherButtonTitles:@"Login", nil];
        [alert show];
    }
    if (picked == YES) {
        NSLog(@"YES");
        [self performSegueWithIdentifier:@"moveToMain" sender:nil];
        return;
    }
}

#pragma mark - Custom Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self performSegueWithIdentifier:@"moveToLogin" sender:nil];
    } else {
        return;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    [appDelegate setGlobalSelectedImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    [splashView setImage:[appDelegate globalSelectedImage]];
    picked = YES;
}

- (void)pickMedia:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
       
    if(sender == libraryBtn) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentModalViewController:picker animated:YES];
}

@end
