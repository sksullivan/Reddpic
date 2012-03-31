//
//  AppDelegate.h
//  Reddpic
//
//  Created by Stephen on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString *globalUhString;
@property (nonatomic, retain) UIImage *globalSelectedImage;
@property (nonatomic, retain) NSString *globalImgurURL;
@property (nonatomic, retain) NSArray *globalCookies;

@end
