//
//  CPRechargeViewController.m
//  ChitPay
//
//  Created by Armia on 10/24/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPRechargeViewController.h"

#import "CPInterswitchPaymentViewController.h"

#import "CPInAppViewController.h"

@interface CPRechargeViewController ()

@end

@implementation CPRechargeViewController

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
    _purchaseController = [[CPInterswitchPaymentViewController alloc]init];
    
    [[SKPaymentQueue defaultQueue]
     addTransactionObserver:_purchaseController];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payInterswitch:(id)sender
{
    CPInterswitchPaymentViewController *InterswitchPaymentViewController = [[CPInterswitchPaymentViewController alloc]initWithNibName:@"CPInterswitchPaymentViewController" bundle:Nil];
    [self.navigationController pushViewController:InterswitchPaymentViewController animated:YES];
}

- (IBAction)payBank:(id)sender
{
    FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"Your account would be credited once payment is received. Following are our account details :-" message:@"Bank	GTBank Plc\nAccount Name	ChitHub Company LTD\nAccount No.	0128220918\n\nBank	Sterling Bank\nAccount Name	ChitHub Company LTD\nAccount No.	0020977989\n\nBank	Zenith Bank\nAccount Name	ChitHub Company LTD\nAccount No.	1013529348\n\nBank	Diamond Bank\nAccount Name	ChitHub Company LTD\nAccount No.	0034236667\n\nBank	First Bank\nAccount Name	ChitHub Company LTD\nAccount No.	2023871755" delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:@"", nil];
    [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
    [alertView.messageLabel setFont:[UIFont systemFontOfSize:10.0]];
    alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
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
    [alertView show];
}

- (IBAction)pay
{
    [SVProgressHUD show];
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"2000.00"];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"ChitPay2000";
    
    // Check whether payment is processable.
    if (!payment.processable)
    {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    // Start out working with the test environment! When you are ready, remove this line to switch to live.
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    
    // Provide a payerId that uniquely identifies a user within the scope of your system,
    // such as an email address or user ID.
    NSString *aPayerId = @"someuser@somedomain.com";
    
    // Create a PayPalPaymentViewController with the credentials and payerId, the PayPalPayment
    // from the previous step, and a PayPalPaymentDelegate to handle the results.
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:@"AcaYzRBlZqFT10QS7a-Iy0AD3XsJ3qu4WgevsyW0TIunU-wwdTw8xPvD7MZI"
                                                                    receiverEmail:@"vishnunair-facilitator@icloud.com"
                                                                          payerId:aPayerId
                                                                          payment:payment
                                                                         delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:^{[self complete];}];
}

- (void)complete
{
    [SVProgressHUD dismiss];
}
#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment
{
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel
{
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment
{
    // Send the entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    NSLog(@"%@\n%@\n%@",[completedPayment.confirmation objectForKey:@"client"],[completedPayment.confirmation objectForKey:@"proof_of_payment"],[completedPayment.confirmation objectForKey:@"payment"]);
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Start out working with the test environment! When you are ready, remove this line to switch to live.
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    [PayPalPaymentViewController prepareForPaymentUsingClientId:@"AcaYzRBlZqFT10QS7a-Iy0AD3XsJ3qu4WgevsyW0TIunU-wwdTw8xPvD7MZI"];
}

- (IBAction)payInapp:(id)sender
{
    CPInAppViewController *InAppViewController = [[CPInAppViewController alloc]initWithNibName:@"CPInAppViewController" bundle:Nil];
    [self.navigationController pushViewController:InAppViewController animated:YES];
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
