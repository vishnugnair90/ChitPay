//
//  CPProfileViewController.m
//  ChitPay
//
//  Created by Armia on 10/10/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPProfileViewController.h"
#import "CPProfileEditViewController.h"
#import "CPPasswordViewController.h"
#import "CPPINViewController.h"

@interface CPProfileViewController ()

@end

@implementation CPProfileViewController

@synthesize lblaccountID,lblName,lbladdress,lblcity,lblemail,lblphone1,lblphone2,lblstate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"notification_count"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"user.get\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<user>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</user>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
    [request startAsynchronous];
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
        NSLog(@"%@",[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"contacts"]objectForKey:@"contact_name"]objectForKey:@"text"]);
        [lblName setText:[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"contacts"]objectForKey:@"contact_name"]objectForKey:@"text"]];
        [lblaccountID setText:[[[[responseDictionary objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]];
        [lblemail setText:[[[[responseDictionary objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"email"]objectForKey:@"text"]];
        [lbladdress setText:[[[[responseDictionary objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"p_address"]objectForKey:@"text"]];
        [lblphone1 setText:[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"contacts"]objectForKey:@"phone1"]objectForKey:@"text"]];
        [lblphone2 setText:[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"contacts"]objectForKey:@"phone2"]objectForKey:@"text"]];
        [lblcity setText:[[[[responseDictionary objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"p_city"]objectForKey:@"text"]];
        [lblstate setText:[[[[responseDictionary objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"p_state"]objectForKey:@"text"]];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Login Failure"];
    }
}

-(IBAction)editAction:(id)sender
{
    //[SVProgressHUD showErrorWithStatus:@"Feature Not Yet Available!"];
    CPProfileEditViewController *ProfileEditViewController = [[CPProfileEditViewController alloc]initWithNibName:@"CPProfileEditViewController" bundle:nil];
    [ProfileEditViewController setStrName:lblName.text];
    [ProfileEditViewController setStrEmail:lblemail.text];
    [ProfileEditViewController setStrPhone1:lblphone1.text];
    [ProfileEditViewController setStrPhone2:lblphone2.text];
    [ProfileEditViewController setStrCity:lblcity.text];
    [ProfileEditViewController setStrState:lblstate.text];
    [ProfileEditViewController setStrAddress:lbladdress.text];
    [self.navigationController pushViewController:ProfileEditViewController animated:YES];
}

-(IBAction)pinAction:(id)sender
{
    //[SVProgressHUD showErrorWithStatus:@"Feature Not Yet Available!"];
    CPPINViewController *INViewController = [[CPPINViewController alloc]initWithNibName:@"CPPINViewController" bundle:nil];
    [self.navigationController pushViewController:INViewController animated:YES];
}

-(IBAction)passwordAction:(id)sender
{
    //[SVProgressHUD showErrorWithStatus:@"Feature Not Yet Available!"];
    CPPasswordViewController *PasswordViewController = [[CPPasswordViewController alloc]initWithNibName:@"CPPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:PasswordViewController animated:YES];
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
@end
