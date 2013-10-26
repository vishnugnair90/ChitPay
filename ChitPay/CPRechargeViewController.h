//
//  CPRechargeViewController.h
//  ChitPay
//
//  Created by Armia on 10/24/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PayPalMobile.h"

@interface CPRechargeViewController : UIViewController<PayPalPaymentDelegate>
{
    
}

- (IBAction)payInterswitch:(id)sender;
- (IBAction)payBank:(id)sender;
@end
