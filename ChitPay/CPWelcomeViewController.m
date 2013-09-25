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

@interface CPWelcomeViewController ()
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"password"]!= nil)
    {
        txtUsername.text = [defaults stringForKey:@"username"];
        txtPassword.text = [defaults stringForKey:@"password"];
    }
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
        NSUserDefaults *defaults = [NSUserDefaults alloc];
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
    }
    else
    {
        [TestFlight passCheckpoint:@"LOGIN FAILED"];
        [SVProgressHUD showErrorWithStatus:@"Login Failure"];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	[SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"Network error"];
}

@end
