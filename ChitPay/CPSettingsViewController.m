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

@interface CPSettingsViewController ()

@end

@implementation CPSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
}

-(IBAction)ProfileAction:(id)sender
{
    NSLog(@"PROFILE");
}

-(IBAction)BalanceAction:(id)sender
{
    NSLog(@"BALANCE");
}

-(IBAction)TransferAction:(id)sender
{
    NSLog(@"TRANSFER");
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
}

-(IBAction)TransactionsAction:(id)sender
{
    NSLog(@"TRANSACTIONS");
}

-(IBAction)LogoutAction:(id)sender
{
    NSLog(@"LOGOUT");
}

@end
