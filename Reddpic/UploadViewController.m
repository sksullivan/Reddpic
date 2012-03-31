//
//  UploadViewController.m
//  Reddpic
//
//  Created by Stephen on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UploadViewController.h"

@implementation UploadViewController

@synthesize submitBtn, uploadImageView, titleFld, srFld, imgurURLString, activityView;

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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [uploadImageView setImage:[appDelegate globalSelectedImage]];
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

- (BOOL)textFieldShouldReturn: (UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *results = [jsonString JSONValue];
    NSLog(@"%@", jsonString);
    
    [submitBtn setHidden:NO];
    [activityView setHidden:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reddpic" 
                                                    message:@"Upload Complete!"
                                                   delegate:self 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)imageUploadedWithURLString:(NSString*)urlString
{
	[appDelegate setGlobalImgurURL:urlString];
    
    NSString *title = [[NSString alloc]initWithString:[titleFld text]];
    NSString *sr = [[NSString alloc]initWithString:[srFld text]];
    NSString *httpBodyString = [[NSString alloc] initWithFormat:@"uh=%@&url=%@&kind=link&sr=%@&title=%@&r=%@&api_type=json",
                                                                [appDelegate globalUhString],
                                                                [appDelegate globalImgurURL],
                                                                sr,
                                                                title,
                                                                sr];
    NSString *redditUrlString = [[NSString alloc] initWithFormat:@"http://www.reddit.com/api/submit/"];
    
    NSLog(@"%@", redditUrlString);
    NSURL *url = [NSURL URLWithString:redditUrlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[appDelegate globalCookies]]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connection)
    {
        NSLog(@"Problem, Sir!");
    }
}

- (void)uploadFailedWithError:(NSError *)error
{
	
}

- (void)uploadProgressedToPercentage:(CGFloat)percentage
{
    
}

- (IBAction)uploadSelectedPhoto:(id)sender
{
    [submitBtn setHidden:YES];
    [activityView setHidden:NO];
    ImgurUploader *i = [[ImgurUploader alloc] init];
    [i setDelegate:self];
    if ([[titleFld text] length] == 0)
    {
        //NSLog(@"notitle");
        [i uploadImage:[appDelegate globalSelectedImage]
            withApiKey:@"67163d7074a14fb896db9e62be9f7b41"
                 title:@""];
        
    } else {
        //NSLog(@"nocaption");
        [i uploadImage:[appDelegate globalSelectedImage]
            withApiKey:@"67163d7074a14fb896db9e62be9f7b41"
                 title:(NSString*)[titleFld text]];
    }
}

@end
