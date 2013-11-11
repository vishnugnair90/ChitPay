//
//  CPInAppViewController.m
//  ChitPay
//
//  Created by Armia on 10/28/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPInAppViewController.h"

#import "CPAPHelper.h"

#import <StoreKit/StoreKit.h>

@interface CPInAppViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_products;
}
@property IBOutlet UITableView *tableView;
@end

@implementation CPInAppViewController

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
    _products = nil;
    [self.tableView reloadData];
    [[CPAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [self.tableView reloadData];
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    SKProduct * product = (SKProduct *) _products[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //NSLog(@"MENU %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"groupname"]objectForKey:@"name"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor dullBlueColor];
    cell.selectedBackgroundView = selectionColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"selected %@",[_products objectAtIndex:indexPath.row]);
    [[CPAPHelper sharedInstance] buyProduct:[_products objectAtIndex:indexPath.row]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ASIFormDataRequest cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification
{
    
    NSString * productIdentifier = [[notification.object componentsSeparatedByString:@"."] objectAtIndex:3];
    
    NSLog(@"BOUGHT %@ for %@ and %@",notification.object,[productIdentifier stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]],[notification.userInfo objectForKey:@"receipt"]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.recharge\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<amount>%@</amount>",[productIdentifier stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<gateway>ITUNES</gateway>"] dataUsingEncoding:NSUTF8StringEncoding]];
     [postBody appendData:[[NSString stringWithFormat:@"<trans_id></trans_id>"] dataUsingEncoding:NSUTF8StringEncoding]];
     [postBody appendData:[[NSString stringWithFormat:@"<ref_id>%@</ref_id>",[notification.userInfo objectForKey:@"receipt"]] dataUsingEncoding:NSUTF8StringEncoding]];
     [postBody appendData:[[NSString stringWithFormat:@"</account>"] dataUsingEncoding:NSUTF8StringEncoding]];
     [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
     [request setPostBody:postBody];
     NSString* newStr = [[NSString alloc] initWithData:postBody
                                              encoding:NSUTF8StringEncoding];
     NSLog(@"POST BODY %@",newStr);
     [SVProgressHUD show];
     request.userInfo = [NSDictionary dictionaryWithObject:@"TRANSACTION" forKey:@"TYPE"];
     [request startAsynchronous];

     /*
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop)
    {
        if ([product.productIdentifier isEqualToString:productIdentifier])
        {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    */
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [SVProgressHUD dismiss];
    NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"%@",responseDictionary);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        [SVProgressHUD showSuccessWithStatus:@"ACCOUNT RECHARGE SUCCESSFULL"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"ACCOUNT RECHARGE FAILED"];
    }
}

@end
