//
//  CPProfileEditViewController.m
//  ChitPay
//
//  Created by Armia on 10/21/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPProfileEditViewController.h"

@interface CPProfileEditViewController ()<UITextFieldDelegate>

@end

@implementation CPProfileEditViewController

@synthesize Email,Name,Phone1,Phone2,Address,City,State;

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
    [Name setText:_strName];
    [Email setText:_strEmail];
    [Address setText:_strAddress];
    [Phone1 setText:_strPhone1];
    [Phone2 setText:_strPhone2];
    [City setText:_strCity];
    [State setText:_strState];
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
-(IBAction)submit:(id)sender
{
    if([self checkFields])
    {
        [SVProgressHUD show];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
        [request setDelegate:self];
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<request method=\"user.update\">"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<user>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<first_name>%@</first_name>",[[Name.text componentsSeparatedByString:@" "] objectAtIndex:0]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<last_name>%@</last_name>",[[Name.text componentsSeparatedByString:@" "] objectAtIndex:1]] dataUsingEncoding:NSUTF8StringEncoding]];
        //[postBody appendData:[[NSString stringWithFormat:@"<email>%@</email>",Email.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<contacts>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<contact>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<email>%@</email>",Email.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<phone1>%@</phone1>",Phone1.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<phone2>%@</phone2>",Phone2.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</contact>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</contacts>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<p_street1>%@</p_street1>",Address.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<p_street2></p_street2>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<p_city>%@</p_city>",City.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<p_state>%@</p_state>",State.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<p_country></p_country>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</user>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setPostBody:postBody];
        [request startAsynchronous];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Please check all the fields."];
    }

}
-(BOOL)checkFields
{
    if([Name.text isEqualToString:@""]||[Phone1.text isEqualToString:@""]||[Phone2.text isEqualToString:@""]||[Address.text isEqualToString:@""]||[City.text isEqualToString:@""]||[State.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"Please fill out all the fields!"];
        return NO;
    }
    else
    {
        if([Name.text componentsSeparatedByString:@" "].count < 2)
        {
            return NO;
        }else
        {
            return YES;
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [SVProgressHUD dismiss];
    NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"%@",responseDictionary);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        [SVProgressHUD showSuccessWithStatus:@"PROFILE UPDATED SUCCESSFULLY"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"ERROR IN UPDATION, please try again"];
        NSLog(@"FAILED");
        
    }
    
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
