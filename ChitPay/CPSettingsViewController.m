//
//  CPSettingsViewController.m
//  ChitPay
//
//  Created by Armia on 10/4/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPSettingsViewController.h"

#import "CPNotificationListViewController.h"

#import "CPNotificationHandler.h"

#import "CPTransactionsViewController.h"

#import "CPWelcomeViewController.h"

#import "CPAppDelegate.h"

#import "CPProfileViewController.h"

#import "CPBalanceViewController.h"

#import "CPStatementViewController.h"

#import "CPTransferViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface CPSettingsViewController ()

@end

@implementation CPSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        for(UIButton *btn in self.view.subviews)
        {
            if([btn isKindOfClass:[UIButton class]])
            {
                //btn.layer.borderWidth = kBorderWidth;
                btn.layer.cornerRadius = kBorderCurve;
            }
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage = [UIImage imageNamed:@"share.png"];
        
        [button setBackgroundImage:backButtonImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showShareMenu) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(0, 0, 30, 30);
        //________________________________________________________________________________________________________
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage1 = [UIImage imageNamed:@"fav.png"];
        
        [button1 setBackgroundImage:backButtonImage1 forState:UIControlStateNormal];
        
        [button1 addTarget:self action:@selector(showFavourites) forControlEvents:UIControlEventTouchUpInside];
        button1.frame = CGRectMake(0, 0, 30, 30);
        //________________________________________________________________________________________________________
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage2 = [UIImage imageNamed:@"settings.png"];
        
        [button2 setBackgroundImage:backButtonImage2 forState:UIControlStateNormal];
        
        [button2 addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
        button2.frame = CGRectMake(0, 0, 30, 30);
        
        //________________________________________________________________________________________________________
        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage3 = [UIImage imageWithColor:[UIColor orangeColor] cornerRadius:3.0];
        
        [button3 setBackgroundImage:backButtonImage3 forState:UIControlStateNormal];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [button3 setTitle:[NSString stringWithFormat:@"%@",[defaults objectForKey:@"notification_count"]] forState:UIControlStateNormal];
        
        [button3 addTarget:self action:@selector(showNotifications) forControlEvents:UIControlEventTouchUpInside];
        
        [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button3.frame = CGRectMake(0, 0, 30, 30);
        
        //________________________________________________________________________________________________________
        
        
        UIBarButtonItem *btnNotifications = [[UIBarButtonItem alloc] initWithCustomView:button3];
        btnNotifications.tintColor = [UIColor yellowColor];
        UIBarButtonItem *btnSharing = [[UIBarButtonItem alloc] initWithCustomView:button];
        btnSharing.tintColor = [UIColor greenColor];
        UIBarButtonItem *btnFavourites = [[UIBarButtonItem alloc] initWithCustomView:button1];
        btnFavourites.tintColor = [UIColor redColor];
        UIBarButtonItem *btnSetting = [[UIBarButtonItem alloc] initWithCustomView:button2];
        btnSetting.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:btnSetting,btnFavourites,btnSharing,btnNotifications, nil];
        
        UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage4 = [UIImage imageNamed:@"Home_logo@2x.png"];
        [button4 addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
        [button4 setBackgroundImage:backButtonImage4 forState:UIControlStateNormal];
        
        button4.frame = CGRectMake(0, 0, 100, 40);
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button4];
        
        self.navigationItem.leftBarButtonItems =[NSArray arrayWithObjects:barButtonItem, nil];
    }
    for(UITextField *field in [self.view subviews])
    {
        if([field isKindOfClass:[UITextField class]])
        {
            field.layer.borderWidth = kBorderWidth;
            field.layer.cornerRadius = kBorderCurve;
            field.font = [UIFont fontWithName:@"LaoUI.ttf" size:field.font.pointSize];
        }
    }
    for(UILabel *label in [self.view subviews])
    {
        if([label isKindOfClass:[UILabel class]])
        {
            //label.layer.borderWidth = kBorderWidth;
            //label.layer.cornerRadius = kBorderCurve;
            label.font = [UIFont fontWithName:@"LaoUI.ttf" size:label.font.pointSize];
        }
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Custom functions

-(IBAction)HomeAction:(id)sender
{
    NSLog(@"HOME");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)ProfileAction:(id)sender
{
    NSLog(@"PROFILE");
    CPProfileViewController *ProfileViewController = [[CPProfileViewController alloc]initWithNibName:@"CPProfileViewController" bundle:nil];
    [self.navigationController pushViewController:ProfileViewController animated:YES];
}

-(IBAction)BalanceAction:(id)sender
{
    NSLog(@"BALANCE");
    CPBalanceViewController *BalanceViewController = [[CPBalanceViewController alloc]initWithNibName:@"CPBalanceViewController" bundle:nil];
    [self.navigationController pushViewController:BalanceViewController animated:YES];
}

-(IBAction)TransferAction:(id)sender
{
    NSLog(@"TRANSFER");
    CPTransferViewController *TransferViewController = [[CPTransferViewController alloc]initWithNibName:@"CPTransferViewController" bundle:nil];
    [self.navigationController pushViewController:TransferViewController animated:YES];
}

-(IBAction)NotificationsAction:(id)sender
{
    NSLog(@"NOTIFICATIONS");
    CPNotificationListViewController *NotificationListViewController = [[CPNotificationListViewController alloc]initWithNibName:@"CPNotificationListViewController" bundle:nil];
    [self.navigationController pushViewController:NotificationListViewController animated:YES];
}

-(IBAction)StatementAction:(id)sender
{
    NSLog(@"STATEMENT");
    CPStatementViewController *StatementViewController = [[CPStatementViewController alloc]initWithNibName:@"CPStatementViewController" bundle:nil];
    [self.navigationController pushViewController:StatementViewController animated:YES];
}

-(IBAction)TransactionsAction:(id)sender
{
    NSLog(@"TRANSACTIONS");
    CPTransactionsViewController *TransactionsListViewController = [[CPTransactionsViewController alloc]initWithNibName:@"CPTransactionsViewController" bundle:nil];
    [self.navigationController pushViewController:TransactionsListViewController animated:YES];
}

-(IBAction)LogoutAction:(id)sender
{
    NSLog(@"LOGOUT");
    CPWelcomeViewController *welcomeViewController = [[CPWelcomeViewController alloc]initWithNibName:@"CPWelcomeViewController" bundle:nil];
    CPAppDelegate *appDelegate = (CPAppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *appNavigationController = [[UINavigationController alloc]initWithRootViewController:welcomeViewController];
    //self.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //self.navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:appNavigationController
                                            animated:YES
                                          completion:^{
                                              
                                              appDelegate.window.rootViewController = appNavigationController;
                                              
                                              
                                          }];
}
- (void)showNotifications
{
    CPNotificationListViewController *NotificationListViewController = [[CPNotificationListViewController alloc]initWithNibName:@"CPNotificationListViewController" bundle:nil];
    [self.navigationController pushViewController:NotificationListViewController animated:YES];
}

- (void)showFavourites
{
    CPFavouritesViewController *FavouritesViewController = [[CPFavouritesViewController alloc]initWithNibName:@"CPFavouritesViewController" bundle:nil];
    [self.navigationController pushViewController:FavouritesViewController animated:YES];
}

- (void)showSettings
{
    CPSettingsViewController *SettingsViewController = [[CPSettingsViewController alloc]initWithNibName:@"CPSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:SettingsViewController animated:YES];
}

- (void)showShareMenu
{
    FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"Share to" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Facebook",@"Google+",@"LinkedIn",@"Twitter", nil];
    alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    alertView.defaultButtonColor = [UIColor midnightBlueColor];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonShadowColor = [UIColor clearColor];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor redColor]];
    alertView.animationDuration = 0.15;
    alertView.tag = 888;
    [alertView show];
}

-(void)pop:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
