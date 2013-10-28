//
//  CPInterswitchPaymentViewController.m
//  ChitPay
//
//  Created by Armia on 10/24/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPInterswitchPaymentViewController.h"

#import <StoreKit/StoreKit.h>

#import "CPRechargeViewController.h"

#import "CPAPHelper.h"

@interface CPInterswitchPaymentViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
{
    NSArray *_products;
}
@property (strong, nonatomic) CPRechargeViewController *homeViewController;
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

    [[CPAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success)
        {
            _products = products;
            NSLog(@"%@",[products objectAtIndex:0]);
        }
    }];
    
    //[self InitiateTransaction];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
