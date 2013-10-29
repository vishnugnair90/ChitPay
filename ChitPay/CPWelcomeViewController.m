//
//  CPWelcomeViewController.m
//  ChitPay
//
//  Created by Armia on 04/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPWelcomeViewController.h"

#import "CPHomeViewController.h"

#import "CPAppDelegate.h"

#import "CPSignupViewController.h"

#import "CPForgotPasswordViewController.h"


@interface CPWelcomeViewController ()<FUIAlertViewDelegate>
@end

@implementation CPWelcomeViewController


@synthesize txtPassword,txtUsername,btnForgotpass,btnLogin,btnSignup;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtUsername.layer.borderWidth = kBorderWidth;
    txtUsername.layer.cornerRadius = kBorderCurve;
    txtPassword.layer.borderWidth = kBorderWidth;
    txtPassword.layer.cornerRadius = kBorderCurve;
    self.navigationController.navigationBar.translucent = NO;
    
    txtUsername.font = [UIFont fontWithName:@"LaoUI" size:20.0];
    // set the text view to the image view
    //self.navigationItem.titleView = imageview;
    //[[UINavigationBar appearance] setItems:[NSArray arrayWithObject:item]];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chit.png"]];
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
    for(UIButton *button in [self.view subviews])
    {
        if([button isKindOfClass:[UIButton class]])
        {
            //label.layer.borderWidth = kBorderWidth;
            //label.layer.cornerRadius = kBorderCurve;
            button.titleLabel.font = [UIFont fontWithName:@"LaoUI.ttf" size:button.titleLabel.font.pointSize];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"password"]!= nil)
    {
        txtUsername.text = [defaults stringForKey:@"username"];
        txtPassword.text = [defaults stringForKey:@"password"];
    }
    //NSLog(@"NOTIFICATION %d",[[CPNotificationHandler singleton]getNotificaton]);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)login:(id)sender
{
    [txtPassword resignFirstResponder];
    [txtUsername resignFirstResponder];
    [SVProgressHUD show];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"user.get\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<user>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",txtUsername.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",txtPassword.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</user>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
    [request startAsynchronous];
}

-(IBAction)signup:(id)sender
{
    CPSignupViewController *signupViewController = [[CPSignupViewController alloc]initWithNibName:@"CPSignupViewController" bundle:nil];
    [self.navigationController pushViewController:signupViewController animated:YES];
}

-(IBAction)forgot:(id)sender
{
    CPForgotPasswordViewController *forgotPasswordViewController = [[CPForgotPasswordViewController alloc]initWithNibName:@"CPForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    
	NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        NSLog(@"PASSED");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:txtUsername.text forKey:@"username"];
        [defaults setObject:txtPassword.text forKey:@"password"];
        [defaults setObject:responseDictionary forKey:@"account_details"];
        [defaults synchronize];
        NSLog(@"%@",responseDictionary);
        [SVProgressHUD showSuccessWithStatus:@"Login Success"];
        CPHomeViewController *homeViewController = [[CPHomeViewController alloc]initWithNibName:@"CPHomeViewController" bundle:nil];
        CPAppDelegate *appDelegate = (CPAppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *appNavigationController = [[UINavigationController alloc]initWithRootViewController:homeViewController];
        [self.navigationController presentViewController:appNavigationController
                                                animated:YES
                                              completion:^{
                                                  appDelegate.window.rootViewController = appNavigationController;
                                              }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Login Failure"];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	[SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"Network error"];
}
-(IBAction)chooseCountry:(id)sender
{
    FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"Choose Country" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Nigeria",@"South Africa", nil];
    alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    alertView.defaultButtonColor = [UIColor midnightBlueColor];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonShadowColor = [UIColor clearColor];
    [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor dullBlueColor]];
    alertView.animationDuration = 0.15;
    alertView.tag = 999;
    [alertView show];
}
-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"CLicked %d",buttonIndex);
}
@end
