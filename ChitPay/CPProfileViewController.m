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
        // Custom initialization
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
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

@end
