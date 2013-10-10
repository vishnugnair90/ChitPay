//
//  CPNotificationHandler.m
//  ChitPay
//
//  Created by Armia on 10/1/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPNotificationHandler.h"

@implementation CPNotificationHandler

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
    //[SVProgressHUD show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
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
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //[SVProgressHUD dismiss];
    
	NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"\n\nRESPONSE\n%d",[[[[responseDictionary objectForKey:@"response"] objectForKey:@"total_records"] objectForKey:@"text"]integerValue]);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        [TestFlight passCheckpoint:@"NOTIFICATIONS REFRESHED"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[[[responseDictionary objectForKey:@"response"] objectForKey:@"total_records"] objectForKey:@"text"] forKey:@"notification_count"];
        [defaults synchronize];

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
@end
