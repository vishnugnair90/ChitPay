//
//  CPPINViewController.m
//  ChitPay
//
//  Created by Armia on 10/21/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPPINViewController.h"

@interface CPPINViewController ()<UITextFieldDelegate>

@end

@implementation CPPINViewController

@synthesize txtNewPIN1,txtNewPIN2,txtOldPIN,accountNumber;

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    accountNumber.text = [[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"];
    for(UITextField *field in [self.view subviews])
    {
        if([field isKindOfClass:[UITextField class]])
        {
            field.layer.borderWidth = kBorderWidth;
            field.layer.cornerRadius = kBorderCurve;
            field.font = [UIFont boldSystemFontOfSize:15.0];
        }
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length >0)
    {
        textField.layer.borderColor = [[UIColor greenColor]CGColor];
    }
    else
    {
        textField.layer.borderColor = [[UIColor redColor]CGColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField.text length]>=3)
    {
        textField.text = [textField.text stringByAppendingString:string];
        [textField resignFirstResponder];
    }
    return YES;
}
- (IBAction)resetPIN:(id)sender
{
    //[SVProgressHUD showErrorWithStatus:@"PIN RESET DISABLED"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.resetPin\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"RESETPIN" forKey:@"TYPE"]];
    [request setPostBody:postBody];
    [SVProgressHUD show];
    [request startAsynchronous];
}

- (IBAction)submit:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.changePin\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<old_pin>%@</old_pin>",txtOldPIN.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<new_pin>%@</new_pin>",txtNewPIN1.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<confirm_pin>%@</confirm_pin>",txtNewPIN2.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"CHANGEPIN" forKey:@"TYPE"]];
    [request setPostBody:postBody];
    [SVProgressHUD show];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [SVProgressHUD dismiss];
    NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"%@",responseDictionary);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        if([[request.userInfo objectForKey:@"TYPE"] isEqualToString:@"CHANGEPIN"])
        {
            [SVProgressHUD showSuccessWithStatus:@"PIN CHANGED SUCCESSFULLY"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"CHECK YOUR MAILBOX FOR NEW PIN"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else
    {
        
        if([[request.userInfo objectForKey:@"TYPE"] isEqualToString:@"CHANGEPIN"])
        {
            [SVProgressHUD showErrorWithStatus:@"INVALID PIN"];
            NSLog(@"FAILED");
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"PLEASE TRY AGAIN"];
            NSLog(@"FAILED");
        }
        
    }
    
}

@end
