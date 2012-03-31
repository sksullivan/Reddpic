//
//  FlipsideViewController.m
//  Reddpic
//
//  Created by Stephen on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController

@synthesize userFld, passwordFld, loginBtn, activityView;
@synthesize delegate = _delegate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    cookieDict = [[NSMutableDictionary alloc] init];
    [editImageView setImage:[appDelegate globalSelectedImage]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)textFieldShouldReturn: (UITextField *)textField {
    if ([textField isSecureTextEntry]) {
        [self loginToReddit]
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark - Actions

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *results = [jsonString JSONValue];
    NSLog(@"%@", results);
    
    NSString *uhString = [[[results objectForKey:@"json"] objectForKey:@"data"] objectForKey:@"modhash"];
    
    if (uhString != nil)
    {
        [activityView setHidden:YES];
        [loginBtn setHidden:NO];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"has_logged_in"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" 
                                                        message:@"Success!"
                                                       delegate:self 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [appDelegate setGlobalUhString:uhString];
        [self performSegueWithIdentifier:@"moveToSplash" sender:nil];
        NSLog(@"%@", uhString);
    } else {
        [activityView setHidden:YES];
        [loginBtn setHidden:NO];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Issue" 
                                                        message:@"Incorrect Username/Password"
                                                       delegate:self 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSString *cookieString = [fields valueForKey:@"Set-Cookie"];
    NSArray *cookieArrayPairs = [cookieString componentsSeparatedByString:@"; "];
    for (NSString *pair in cookieArrayPairs)
    {
        NSArray *values = [pair componentsSeparatedByString:@"="];
        NSString *key = [values objectAtIndex:0];
        NSString *value = [values objectAtIndex:1];
        
        [cookieDict setValue:value forKey:key];
    }
    NSString *uhString = [cookieDict objectForKey:@"reddit_session"];
    
    if (uhString != nil)
    {
        NSArray* allCookies =
        [NSHTTPCookie cookiesWithResponseHeaderFields:[HTTPResponse allHeaderFields]
                                               forURL:[NSURL URLWithString:@".reddit.com"]];
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:allCookies
                                                           forURL:[NSURL URLWithString:@".reddit.com"]
                                                  mainDocumentURL:nil];
        
        [appDelegate setGlobalCookies:allCookies];
    }
}

- (void)loginToReddit //TODO: CHANGE THIS METHOD NAME
{
    [activityView setHidden:NO];
    [loginBtn setHidden:YES];
    NSString *user = [[NSString alloc]initWithString:[userFld text]];
    NSString *passwd = [[NSString alloc]initWithString:[passwordFld text]];
    NSString *httpBodyString = [[NSString alloc] initWithFormat:@"user=%@&passwd=%@&api_type=json", user, passwd];
    NSString *urlString = [NSString stringWithFormat:@"http://www.reddit.com/api/login/",
                           [user stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
                           [passwd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connection)
    {
        NSLog(@"Problem, Sir!");
    }
}


- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}
@end
