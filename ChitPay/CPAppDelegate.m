//
//  CPAppDelegate.m
//  ChitPay
//
//  Created by Armia on 04/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPAppDelegate.h"

#import "CPWelcomeViewController.h"

#import "CPNotificationHandler.h"

@implementation CPAppDelegate

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    CPWelcomeViewController *welcomeViewController = [[CPWelcomeViewController alloc] initWithNibName:@"CPWelcomeViewController" bundle:nil];
    navigationController = [[UINavigationController alloc]initWithRootViewController:welcomeViewController];
    self.window.rootViewController = navigationController;
    //UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    //[[UINavigationBar appearance]addSubview:img];
    // Create your image
    
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    // Set the background image for *all* UINavigationBars
    // Set the background image for *all* UINavigationBars
    [[UIBarButtonItem appearance]
     setBackButtonBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:10.0]
     forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTranslucent:NO];
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor dullBlueColor],
      UITextAttributeTextColor,
      [UIColor clearColor],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
      UITextAttributeTextShadowOffset,
      [UIFont boldSystemFontOfSize:15.0],
      UITextAttributeFont,
      nil]forState:UIControlStateNormal];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    [[CPNotificationHandler singleton]getNotificaton];    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[CPNotificationHandler singleton]getNotificaton];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
@end
