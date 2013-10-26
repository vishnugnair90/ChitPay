//
//  CPInterswitchPaymentViewController.m
//  ChitPay
//
//  Created by Armia on 10/24/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPInterswitchPaymentViewController.h"

@interface CPInterswitchPaymentViewController ()

@end

@implementation CPInterswitchPaymentViewController

@synthesize paymentWebView;

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
    [self InitiateTransaction];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)InitiateTransaction
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://stageserv.interswitchng.com/test_paydirect/pay"]];
    [request setDelegate:self];
    
    [request setUseKeychainPersistence:YES];
    [request setUseSessionPersistence:YES];
    [request setUseCookiePersistence:YES];
    

    [request setRequestMethod:@"POST"];
    [request setPostValue:@"product_id" forKey:@"4220"];
    [request setPostValue:@"pay_item_id" forKey:@"101"];
    [request setPostValue:@"amount" forKey:@"100"];
    [request setPostValue:@"currency" forKey:@"566"];
    [request setPostValue:@"cust_id" forKey:@"123"];
    [request setPostValue:@"cust_name" forKey:@"abc"];
    [request setPostValue:@"site_redirect_url" forKey:@"http://google.com/"];
    [request setPostValue:@"txn_ref" forKey:@"198912334"];
    [request setPostValue:@"hash" forKey:@"e349094dedeb14e56eb8ab1befdb01f6fb7d0cb50aa7d23ef140e09c48657e452a9bfe7f08fb4fa1cc30e14d77a001b51b72239fce1aff33b923161eb60eae0d"];
    
    /*
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.changePin\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<input name=\"product_id\" type=\"hidden\" value=\"4220\" />"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<input name=\"pay_item_id\" type=\"hidden\" value=\"101\" />"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<input name=\"amount\" type=\"hidden\" value=\"100\" />"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<input name=\"currency\" type=\"hidden\" value=\"566\" />"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<input name=\"cust_id\" type=\"hidden\" value=\"123\" />"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<input name=\"cust_name\" type=\"hidden\" value=\"abc\" />"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<input name=\"site_redirect_url\" type=\"hidden\" value=\"http://google.com/\"/>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<input name=\"txn_ref\" type=\"hidden\" value=\"1198912334\" />"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<input name=\"hash\" type=\"hidden\" value=\"d2aba5d31a2ec6a7df405cf95dc41d2bbd8e7ae07bcd45661f1e1ea6eff6a0c61106187107e340f177d1309fbde7c1b5933e6760bbda46e6026d99b8c97228f6\" />"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
     */
    [SVProgressHUD show];
    NSLog(@"%@",[request postBodyFilePath]);
    [request startAsynchronous];
     
    //[paymentWebView loadRequest:request];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [SVProgressHUD dismiss];
    NSLog(@"%@",[request responseString]);
    /*
    NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"%@",responseDictionary);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        NSLog(@"SUCCESS");
    }
    else
    {
        NSLog(@"FAILURE");
    }
    */
    NSError *error = [request error];
    if (!error)
    {
        [paymentWebView loadData:[request responseData] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[request url]];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"START LOAD");
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"FINISH LOAD");
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
@end
