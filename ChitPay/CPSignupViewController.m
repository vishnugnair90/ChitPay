//
//  CPSignupViewController.m
//  ChitPay
//
//  Created by Armia on 05/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPSignupViewController.h"

#import "CPSignupDetailViewController.h"

#define kOFFSET_FOR_KEYBOARD 180.0

@interface CPSignupViewController ()

@end

@implementation CPSignupViewController

@synthesize txtEmail,txtPassword1,txtPassword2,txtUsername;

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
     [TestFlight passCheckpoint:@"SIGNUP START"];
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
    return YES;
}

-(BOOL)checkFields
{
    if([txtEmail.text isEqualToString:@""]||[txtUsername.text isEqualToString:@""]||[txtPassword1.text isEqualToString:@""]||[txtPassword2.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"Please fill out all the fields!"];
        return NO;
    }
    else
    {
        if(![txtPassword1.text isEqualToString:txtPassword2.text])
        {
            [SVProgressHUD showErrorWithStatus:@"Passwords do not match!"];
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

-(IBAction)next:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtUsername resignFirstResponder];
    [txtPassword1 resignFirstResponder];
    [txtPassword2 resignFirstResponder];
    if  (self.view.frame.origin.y < 0)
    {
        [self keyboardWillHide];
    }
    if([self checkFields])
    {
        [TestFlight passCheckpoint:@"SIGNUP STAGE 1 OK"];
        CPSignupDetailViewController *signupDetailViewController = [[CPSignupDetailViewController alloc]initWithNibName:@"CPSignupDetailViewController" bundle:nil];
        [signupDetailViewController setStrEmail:txtEmail.text];
        [signupDetailViewController setStrUsername:txtUsername.text];
        [signupDetailViewController setStrPassword:txtPassword1.text];
        [self.navigationController pushViewController:signupDetailViewController animated:YES];
    }
}


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
    if ([sender isEqual:txtPassword1]||[sender isEqual:txtPassword2])
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

-(IBAction)cancel:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
