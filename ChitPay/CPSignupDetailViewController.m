//
//  CPSignupDetailViewController.m
//  ChitPay
//
//  Created by Armia on 05/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPSignupDetailViewController.h"

#import "CPHomeViewController.h"

#import "CPAppDelegate.h"

#define kOFFSET_FOR_KEYBOARD 215.0

@interface CPSignupDetailViewController ()

@end

@implementation CPSignupDetailViewController

@synthesize txtCity,txtFirstName,txtLastName,txtPhone1,txtPhone2,txtState,txtStreet1,txtStreet2,strEmail,strPassword,strUsername;

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
    for(UITextField *field in [self.view subviews])
    {
        if([field isKindOfClass:[UITextField class]])
        {
            field.layer.borderWidth = kBorderWidth;
            field.layer.cornerRadius = kBorderCurve;
            field.font = [UIFont boldSystemFontOfSize:15.0];
        }
    }
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if  (self.view.frame.origin.y < 0)
    {
        [self keyboardWillHide];
    }
    return YES;}



-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide
{
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:txtStreet1]||[sender isEqual:txtStreet2]||[sender isEqual:txtCity]||[sender isEqual:txtState])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        NSLog(@"screen %f",[[UIScreen mainScreen] applicationFrame].size.height);
        if (screenRect.size.height == 548)
        {
            rect.origin.y -= kOFFSET_FOR_KEYBOARD-88;
            rect.size.height += kOFFSET_FOR_KEYBOARD-88;
            NSLog(@"iphone 5");
        }
        else
        {
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
            rect.size.height += kOFFSET_FOR_KEYBOARD;
        }
    }
    else
    {
        // revert back to the normal state.
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        if (screenRect.size.height == 548)
        {
            rect.origin.y += kOFFSET_FOR_KEYBOARD -88;
            rect.size.height -= kOFFSET_FOR_KEYBOARD -88;
        }
        else
        {
            rect.origin.y += kOFFSET_FOR_KEYBOARD;
            rect.size.height -= kOFFSET_FOR_KEYBOARD;
        }
        
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(BOOL)checkFields
{
    if([txtFirstName.text isEqualToString:@""]||[txtLastName.text isEqualToString:@""]||[txtPhone1.text isEqualToString:@""]||[txtPhone2.text isEqualToString:@""]||[txtStreet1.text isEqualToString:@""]||[txtStreet2.text isEqualToString:@""]||[txtCity.text isEqualToString:@""]||[txtState.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"Please fill out all the fields!"];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(IBAction)signup:(id)sender
{
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtPhone1 resignFirstResponder];
    [txtPhone2 resignFirstResponder];
    [txtStreet1 resignFirstResponder];
    [txtStreet2 resignFirstResponder];
    [txtCity resignFirstResponder];
    [txtState resignFirstResponder];
    if  (self.view.frame.origin.y < 0)
    {
        [self keyboardWillHide];
    }
    if([self checkFields])
    {
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        
        NSLog(@"DATA TO BE SENT\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",txtFirstName.text,txtLastName.text,strEmail,strUsername,strPassword,txtPhone1.text,txtPhone2.text,txtStreet1.text,txtStreet2.text,txtCity.text,txtState.text);
        
        [SVProgressHUD show];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
        [request setDelegate:self];
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<request method=\"user.create\">"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<user>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<first_name>%@</first_name>",txtFirstName.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<last_name>%@</last_name>",txtLastName.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<email>%@</email>",strEmail] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",strUsername] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",strPassword] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<contacts>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<contact>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<email>%@</email>",strEmail] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<phone1>%@</phone1>",txtPhone1.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<phone2>%@</phone2>",txtPhone2.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</contact>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</contacts>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<p_street1>%@</p_street1>",txtStreet1.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<p_street2>%@</p_street2>",txtStreet2.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<p_city>%@</p_city>",txtCity.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<p_state>%@</p_state>",txtState.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<p_country></p_country>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</user>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setPostBody:postBody];
        NSLog(@"POSTING DATA %@",postBody);
        [request startAsynchronous];
        
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    
	NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"\n\nRESPONSE\n%@",responseDictionary);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        [TestFlight passCheckpoint:@"SIGN UP OK"];
        [SVProgressHUD showSuccessWithStatus:@"Signup Success"];
        
        NSUserDefaults *defaults = [NSUserDefaults alloc];
        [defaults setObject:strUsername forKey:@"username"];
        [defaults setObject:strPassword forKey:@"password"];
        [defaults setObject:strEmail forKey:@"email"];
        [defaults setObject:responseDictionary forKey:@"account_details"];
        [defaults synchronize];
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
        [SVProgressHUD showErrorWithStatus:@"Signup Failure"];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSString *receivedString = [request responseString];
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:receivedString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
}

-(IBAction)cancel:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
