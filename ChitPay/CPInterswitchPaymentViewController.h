//
//  CPInterswitchPaymentViewController.h
//  ChitPay
//
//  Created by Armia on 10/24/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>



@interface CPInterswitchPaymentViewController : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    
}
@property IBOutlet UIWebView *paymentWebView;

- (IBAction)buyProduct:(id)sender;

@end
