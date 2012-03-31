//
//  ThoughtSender.m
//  ThoughtBackDesktop
//
//  Created by Randall Brown on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurUploader.h"
#import "NSString+URLEncoding.h"
#import "NSData+Base64.h"
#import "AppDelegate.h"
#import <dispatch/dispatch.h>

@implementation ImgurUploader

@synthesize delegate;

- (void)uploadImage:(UIImage*)image
        withApiKey:(NSString *)apiKey
             title:(NSString *)title
{
	dispatch_queue_t queue = dispatch_queue_create("com.Blocks.task",NULL);
	dispatch_queue_t main = dispatch_get_main_queue();
	
	dispatch_async(queue,^{
		NSData   *imageData  = UIImageJPEGRepresentation(image, 0.3); // High compression due to 3G.
		
		NSString *imageB64   = [imageData base64EncodingWithLineLength:0];
		imageB64 = [imageB64 encodedURLString];
		
		dispatch_async(main,^{
			
			NSString *uploadCall = [NSString stringWithFormat:@"key=%@&image=%@&title=%@", apiKey, imageB64, title];
			
			NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.imgur.com/2/upload.xml"]];
			[request setHTTPMethod:@"POST"];
			[request setValue:[NSString stringWithFormat:@"%d",[uploadCall length]] forHTTPHeaderField:@"Content-length"];
			[request setHTTPBody:[uploadCall dataUsingEncoding:NSUTF8StringEncoding]];
			NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            
			if (connection) 
			{
				receivedData = [NSMutableData data];
			} 
			else 
			{
				
			}
		});
	});  		
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[delegate uploadFailedWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	[delegate uploadProgressedToPercentage:(CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{	
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:receivedData];
	[parser setDelegate:self];
	[parser parse];
}

-(void)parserDidEndDocument:(NSXMLParser*)parser
{
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate setGlobalImgurURL:imageURL];
    
    [delegate imageUploadedWithURLString:imageURL];
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentNode = elementName;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [currentNode isEqualToString:elementName] )
	{
		currentNode = @"";
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( [currentNode isEqualToString:@"original"] )
	{
		imageURL = string;
	}
}

@end
