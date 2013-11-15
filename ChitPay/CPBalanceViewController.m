//
//  CPBalanceViewController.m
//  ChitPay
//
//  Created by Armia on 10/10/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPBalanceViewController.h"

#import "CPTransferViewController.h"

#import "CPRechargeViewController.h"

#import "CPStatementViewController.h"

@interface CPBalanceViewController ()

@end

@implementation CPBalanceViewController

@synthesize lblaccountID,lblName,lblBalance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"VIEWCONTROLLERS %@",self.navigationController.viewControllers);
    [super viewDidLoad];
    [SVProgressHUD show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.getDetails\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
    [request startAsynchronous];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    
	NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"%@",responseDictionary);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        /*
         NSLog(@"PASSED");
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:txtUsername.text forKey:@"username"];
         [defaults setObject:txtPassword.text forKey:@"password"];
         [defaults setObject:responseDictionary forKey:@"account_details"];
         [defaults synchronize];
         NSLog(@"%@",responseDictionary);
         [TestFlight passCheckpoint:@"LOGIN OK"];
         [SVProgressHUD showSuccessWithStatus:@"Login Success"];
         CPHomeViewController *homeViewController = [[CPHomeViewController alloc]initWithNibName:@"CPHomeViewController" bundle:nil];
         CPAppDelegate *appDelegate = (CPAppDelegate *)[[UIApplication sharedApplication] delegate];
         UINavigationController *appNavigationController = [[UINavigationController alloc]initWithRootViewController:homeViewController];
         [self.navigationController presentViewController:appNavigationController
         animated:YES
         completion:^{
         appDelegate.window.rootViewController = appNavigationController;
         }];
         */
        [lblName setText:[[[[responseDictionary objectForKey:@"response"]objectForKey:@"account"]objectForKey:@"account_name"]objectForKey:@"text"]];
        [lblaccountID setText:[[[[responseDictionary objectForKey:@"response"]objectForKey:@"account"]objectForKey:@"account_no"]objectForKey:@"text"]];
        [lblBalance setText:[[[[responseDictionary objectForKey:@"response"]objectForKey:@"account"]objectForKey:@"balance"]objectForKey:@"text"]];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Login Failure"];
    }
}

-(IBAction)transactionStatementAction:(id)sender
{
    CPStatementViewController *StatementViewController = [[CPStatementViewController alloc]initWithNibName:@"CPStatementViewController" bundle:nil];
    [self.navigationController pushViewController:StatementViewController animated:YES];
}

-(IBAction)transferFundsAction:(id)sender
{
    CPTransferViewController *TransferViewController = [[CPTransferViewController alloc]initWithNibName:@"CPTransferViewController" bundle:nil];
    [self.navigationController pushViewController:TransferViewController animated:YES];
}

-(IBAction)rechargeAccountAction:(id)sender
{
    CPRechargeViewController *RechargeViewController = [[CPRechargeViewController alloc]initWithNibName:@"CPRechargeViewController" bundle:nil];
    [self.navigationController pushViewController:RechargeViewController animated:YES];
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
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context
{
    if([keyPath isEqual:@"notification_count"])
    {
        NSLog(@"SomeKey change: %@", change);
        UIBarButtonItem *btnBar = [self.navigationItem.rightBarButtonItems objectAtIndex:3];
        UIButton *btn = (UIButton *)btnBar.customView;
        [btn setTitle:[NSString stringWithFormat:@"%@",[change objectForKey:@"new"]] forState:UIControlStateNormal];
    }
}

-( void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}
@end
