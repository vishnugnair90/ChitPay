//
//  CPTransferViewController.m
//  ChitPay
//
//  Created by Armia on 10/17/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPTransferViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface CPTransferViewController ()
{
    NSString *PIN;
}

@end

@implementation CPTransferViewController

@synthesize txtAccountNo,txtAmount,txtComment,lblName;

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

-(IBAction)ProceedAction:(id)sender
{
    FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"ENTER PIN" message:@"" delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:@"", nil];
    alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    alertView.defaultButtonColor = [UIColor midnightBlueColor];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonShadowColor = [UIColor clearColor];
    alertView.defaultButtonColor = [UIColor clearColor];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor dullBlueColor]];
    alertView.animationDuration = 0.15;
    alertView.tag = 999;
    UIButton *button = [[alertView buttons]objectAtIndex:1];
    NSLog(@"%f %f %f %f",button.frame.origin.x,button.frame.origin.y,button.frame.size.height,button.frame.size.width);
    [button setUserInteractionEnabled:FALSE];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(alertView.frame.origin.x+15, alertView.frame.origin.y+58, 250, 46)];
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.tag = 909;
    textField.clearsOnBeginEditing = YES;
    textField.delegate = self;
    [alertView.alertContainer addSubview:textField];
    [alertView show];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtAccountNo.layer.borderWidth = kBorderWidth;
    txtAccountNo.layer.cornerRadius = kBorderCurve;
    txtAccountNo.layer.borderColor = [[UIColor clearColor]CGColor];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"CHANGED length = %d",textField.text.length);
    if(textField.tag == 909)
    {
        if([textField.text length]>=3)
        {
            textField.text = [textField.text stringByAppendingString:string];
            PIN = textField.text;
            [textField resignFirstResponder];
        }
    }
    return YES;
}

-(IBAction)ValidateAccountAction:(id)sender
{
    NSLog(@"START VALIDATION");
    [SVProgressHUD show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.authenticate\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",txtAccountNo.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"ACCOUNTAUTHENTICATION" forKey:@"TYPE"]];
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
        if([[request.userInfo objectForKey:@"TYPE"] isEqualToString:@"ACCOUNTAUTHENTICATION"])
        {
            //[self LoadNotificationData];
            NSLog(@"DONE");
            txtAccountNo.layer.borderWidth = kBorderWidth;
            txtAccountNo.layer.cornerRadius = kBorderCurve;
            txtAccountNo.layer.borderColor = [[UIColor greenColor]CGColor];
            [lblName setText:[[[[responseDictionary objectForKey:@"response"]objectForKey:@"account"]objectForKey:@"account_name"]objectForKey:@"text"]];
            [lblName setHidden:NO];
            [txtAmount setHidden:NO];
            [txtComment setHidden:NO];

        }
        else
        {
            NSString *receivedString = [request responseString];
            NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
            
            if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
            {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"AMOUNT TRANSFER SUCCESSFUL\n Balance: %@\n Transaction id: %@",[[[[responseDictionary objectForKey:@"response"]objectForKey:@"account"]objectForKey:@"balance"]objectForKey:@"text"],[[[[responseDictionary objectForKey:@"response"]objectForKey:@"account"]objectForKey:@"transaction_id"]objectForKey:@"text"]]];
                
                FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"TRANSACTION SUCCESS" message:[NSString stringWithFormat:@"PIN    %@\nSERIAL  %@\nBATCH   %@",[[[[[[responseDictionary objectForKey:@"response"] objectForKey:@"transaction"] objectForKey:@"pin_details"]objectForKey:@"pin"]objectForKey:@"pin_no"] objectForKey:@"text"],[[[[[[responseDictionary objectForKey:@"response"] objectForKey:@"transaction"] objectForKey:@"pin_details"]objectForKey:@"pin"]objectForKey:@"pin_serial"] objectForKey:@"text"],[[[[[[responseDictionary objectForKey:@"response"] objectForKey:@"transaction"] objectForKey:@"pin_details"]objectForKey:@"pin"]objectForKey:@"pin_batch"] objectForKey:@"text"]] delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles: nil];
                alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
                alertView.defaultButtonColor = [UIColor midnightBlueColor];
                alertView.alertContainer.backgroundColor = [UIColor whiteColor];
                alertView.defaultButtonShadowColor = [UIColor clearColor];
                alertView.defaultButtonTitleColor = [UIColor whiteColor];
                [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
                [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor greenColor]];
                alertView.animationDuration = 0.15;
                alertView.tag = 888;
                [alertView show];
            }
        }
        
    }
    else
    {
        txtAccountNo.layer.borderWidth = kBorderWidth;
        txtAccountNo.layer.cornerRadius = kBorderCurve;
        txtAccountNo.layer.borderColor = [[UIColor redColor]CGColor];
        
        [SVProgressHUD showErrorWithStatus:@"INVALID ACCOUNT NUMBER"];
        NSLog(@"FAILED");

    }
    
}
-(void)Submit:(id)sender
{
    [SVProgressHUD show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.transfer\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<sender_account_no>%@</sender_account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<receiver_account_no>%@</receiver_account_no>",txtAccountNo.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<amount>%@</amount>",txtAmount.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<pin>%@</pin>",PIN] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<notes>%@</notes>",txtComment.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"ACCOUNTTRANSFER" forKey:@"TYPE"]];
    [request setPostBody:postBody];
    [SVProgressHUD show];
    [request startAsynchronous];
}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag != 999)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [self Submit:self];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
