//
//  CPNotificationHandler.m
//  ChitPay
//
//  Created by Armia on 10/1/13.
//  Copyright (c) 2013 Armia. All rights reserved.

 


@implementation CPNotificationHandler
{
    NSString *PIN;
    NSString *uid;
    FUIAlertView *alertView;
}

+(CPNotificationHandler *)singleton
{
    static dispatch_once_t pred;
    static CPNotificationHandler *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[CPNotificationHandler alloc] init];
    });
    return shared;
}

-(void)getNotificaton
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"notification.list\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<notification>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<pin>%d</pin>",1234] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</notification>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"NOTIFICATIONREFRESH" forKey:@"CALLTYPE"]];
    [request startAsynchronous];
    [SVProgressHUD show];
}

- (void)linkDevice
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"device.register\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<device>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<code>%@</code>",[defaults objectForKey:@"deviceToken"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</device>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
    NSLog(@"REQUEST BODY \n%@",[defaults objectForKey:@"devicetoken"]);
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"ADDDEVICE" forKey:@"CALLTYPE"]];
    if(![[defaults objectForKey:@"devicetoken"] isEqualToString:NULL])
        [request startAsynchronous];
    else
        [SVProgressHUD showErrorWithStatus:@"DEVICE TOKEN ERROR"];
        
    
}

- (void)delinkDevive
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"device.unregister\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<device>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<code>%@</code>",[defaults objectForKey:@"deviceToken"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</device>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"REMOVEDEVICE" forKey:@"CALLTYPE"]];
    if(![[defaults objectForKey:@"devicetoken"] isEqualToString:NULL])
        [request startAsynchronous];
    else
        [SVProgressHUD showErrorWithStatus:@"DEVICE TOKEN ERROR"];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    
	NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"DATA %@ \n\nRESPONSE\n%d",responseDictionary,[[[[responseDictionary objectForKey:@"response"] objectForKey:@"total_records"] objectForKey:@"text"]integerValue]);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        if([[request.userInfo objectForKey:@"CALLTYPE"] isEqualToString:@"NOTIFICATIONREFRESH"])
        {
            //[self LoadNotificationData];
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:[[[responseDictionary objectForKey:@"response"] objectForKey:@"total_records"] objectForKey:@"text"] forKey:@"notification_count"];
//            [defaults synchronize];
        }
        if([[request.userInfo objectForKey:@"CALLTYPE"] isEqualToString:@"ADDDEVICE"])
        {
            [SVProgressHUD showSuccessWithStatus:@"Device linked with user"];
        }
        if([[request.userInfo objectForKey:@"CALLTYPE"] isEqualToString:@"REMOVEDEVICE"])
        {
            [SVProgressHUD showSuccessWithStatus:@"Device de-linked with user"];
        }
        if([[request.userInfo objectForKey:@"CALLTYPE"] isEqualToString:@"ACCEPTOFFER"])
        {
            [SVProgressHUD showSuccessWithStatus:@"OFFER ACCEPTED"];
        }
        if([[request.userInfo objectForKey:@"CALLTYPE"] isEqualToString:@"DECLINEOFFER"])
        {
            [SVProgressHUD showSuccessWithStatus:@"OFFER REJECTED"];
        }
        if([[request.userInfo objectForKey:@"CALLTYPE"] isEqualToString:@"REFRESHUSER"])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:responseDictionary forKey:@"account_details"];
            [defaults synchronize];
        }

        //[SVProgressHUD showSuccessWithStatus:@"NOTIFICATIONS REFRESHED"];
    }
    else
    {
        //[SVProgressHUD showErrorWithStatus:@"NOTIFICATIONS REFRESH FAILED"];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	
}

-(void)crediAction:(NSDictionary *)payload
{
    NSLog(@"PAYLOAD %@\nAMOUNT %@\nUSER %@\nID %@",[payload objectForKey:@"details"],[[payload objectForKey:@"details"]objectForKey:@"amt"],[[payload objectForKey:@"details"]objectForKey:@"sender"],[[payload objectForKey:@"details"]objectForKey:@"uid"]);
    alertView = [[FUIAlertView alloc]initWithTitle:@"AMOUNT CREDITED" message:[NSString stringWithFormat:@"%@N CREDITED by %@ \nenter PIN to confirm",[[payload objectForKey:@"details"]objectForKey:@"amt"],[[payload objectForKey:@"details"]objectForKey:@"sender"]] delegate:self cancelButtonTitle:@"ACCEPT" otherButtonTitles:@"DECLINE",@"DECLINE", nil];
    alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    alertView.defaultButtonColor = [UIColor redColor];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonShadowColor = [UIColor clearColor];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor dullBlueColor]];
    alertView.animationDuration = 0.15;
    alertView.defaultButtonCornerRadius = 10.0;
    alertView.alertContainer.layer.cornerRadius = 10.0;
    alertView.tag = 999;
    uid =[[payload objectForKey:@"details"]objectForKey:@"uid"];
    UIButton *button = [[alertView buttons]objectAtIndex:1];
    NSLog(@"%f %f %f %f",button.frame.origin.x,button.frame.origin.y,button.frame.size.height,button.frame.size.width);
    [button setUserInteractionEnabled:FALSE];
    
    UIImage *normalBackgroundImage = [UIImage buttonImageWithColor:[UIColor clearColor]
                                                      cornerRadius:button.layer.cornerRadius
                                                       shadowColor:alertView.defaultButtonShadowColor
                                                      shadowInsets:UIEdgeInsetsMake(0, 0, alertView.defaultButtonShadowHeight, 0)];
    UIImage *highlightedBackgroundImage = [UIImage buttonImageWithColor:[UIColor clearColor]
                                                           cornerRadius:button.layer.cornerRadius
                                                            shadowColor:[UIColor clearColor]
                                                           shadowInsets:UIEdgeInsetsMake(alertView.defaultButtonShadowHeight, 0, 0, 0)];
    
    [button setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor clearColor]];
    
    
    
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(alertView.frame.origin.x+15, alertView.frame.origin.y + 100, 250, 30)];

    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.tag = 909;
    textField.clearsOnBeginEditing = YES;
    textField.secureTextEntry = YES;
    textField.delegate = self;
    [alertView.alertContainer addSubview:textField];
    
    UIButton *btn = [[alertView buttons] objectAtIndex:0];
    btn.hidden =YES;
    UIButton *btn1 = [[alertView buttons] objectAtIndex:2];
    btn1.hidden =YES;
    
    [alertView show];
}
-(void)respondAction:(NSDictionary *)payload
{
    NSLog(@"PAYLOAD %@\nAMOUNT %@\nUSER %@\nID %@",[payload objectForKey:@"details"],[[payload objectForKey:@"details"]objectForKey:@"amt"],[[payload objectForKey:@"details"]objectForKey:@"sender"],[[payload objectForKey:@"details"]objectForKey:@"uid"]);
    alertView = [[FUIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"AMOUNT CREDIT OFFER %@ by %@",[[payload objectForKey:@"details"]objectForKey:@"type"],[[payload objectForKey:@"details"]objectForKey:@"sender"]] message:nil delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:nil];
    alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    alertView.defaultButtonColor = [UIColor redColor];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonShadowColor = [UIColor clearColor];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor dullBlueColor]];
    alertView.animationDuration = 0.15;
    alertView.defaultButtonCornerRadius = 10.0;
    alertView.alertContainer.layer.cornerRadius = 10.0;
    alertView.tag = 777;
    [alertView show];
}


- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"CLICKED %d",buttonIndex);
    if(buttonIndex == 0)
    {
        NSLog(@"ACCEPTED");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
        [request setDelegate:self];
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.pay\">"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<account>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<unique_id>%@</unique_id>",uid] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<trans_status>Completed</trans_status>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<pin>%@</pin>",PIN] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<notes></notes>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</account>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setPostBody:postBody];
        [request setUserInfo:[NSDictionary dictionaryWithObject:@"ACCEPTOFFER" forKey:@"CALLTYPE"]];
        [SVProgressHUD show];
        [request startAsynchronous];
    }
    if (buttonIndex ==2)
    {
        NSLog(@"DECLINED");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
        [request setDelegate:self];
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.pay\">"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<account>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<unique_id>%@</unique_id>",uid] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<trans_status>Declined</trans_status>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<pin>%@</pin>",PIN] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<notes></notes>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</account>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setPostBody:postBody];
        [request setUserInfo:[NSDictionary dictionaryWithObject:@"DECLINEOFFER" forKey:@"CALLTYPE"]];
        [SVProgressHUD show];
        [request startAsynchronous];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
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
            UIButton *btn = [[alertView buttons] objectAtIndex:0];
            btn.hidden =NO;
            UIButton *btn1 = [[alertView buttons] objectAtIndex:2];
            btn1.hidden =NO;
            [textField resignFirstResponder];
        }
    }
    NSLog(@"PIN %@",PIN);
    return YES;
}
-(void)refreshUser
{
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
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"REFRESHUSER" forKey:@"CALLTYPE"]];
    [request setPostBody:postBody];
    [request startAsynchronous];
}

@end
