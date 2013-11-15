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

#import "CPAPHelper.h"

#import "CPNotificationListViewController.h"

@implementation CPAppDelegate

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CPAPHelper sharedInstance];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    CPWelcomeViewController *welcomeViewController = [[CPWelcomeViewController alloc] initWithNibName:@"CPWelcomeViewController" bundle:nil];
    navigationController = [[UINavigationController alloc]initWithRootViewController:welcomeViewController];
    self.window.rootViewController = navigationController;
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
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeGesture.numberOfTouchesRequired = 1;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.window addGestureRecognizer:swipeGesture];
    [self.window makeKeyAndVisible];
    
    if(launchOptions != Nil)
    {
        NSLog(@"Launch %@",[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]);
        [[CPNotificationHandler singleton] crediAction:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
    }
    else
    {
        NSLog(@"Launch NO DATA");
    }
    
    
    return YES;
}

- (void) swipedScreen:(UISwipeGestureRecognizer*)swipeGesture
{
    // do stuff
    [[CPNotificationHandler singleton]getNotificaton];
    UINavigationController *myNavCon = (UINavigationController*)self.window.rootViewController;
    NSLog(@"ACTION %@",myNavCon.viewControllers);
    [myNavCon popViewControllerAnimated:YES];
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
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:hexToken forKey:@"deviceToken"];
    [defaults synchronize];
    [[CPNotificationHandler singleton]getNotificaton];
    NSLog(@"My token is: %@", hexToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"NOTIFICATION %@",userInfo);

    [[CPNotificationHandler singleton]getNotificaton];
    
    [[CPNotificationHandler singleton] crediAction:userInfo];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
@end
