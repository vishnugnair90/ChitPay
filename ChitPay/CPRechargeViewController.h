//
//  CPRechargeViewController.h
//  ChitPay
//
//  Created by Armia on 10/24/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PayPalMobile.h"

#import <StoreKit/StoreKit.h>
#import "CPInterswitchPaymentViewController.h"

@interface CPRechargeViewController : UIViewController<PayPalPaymentDelegate>
{
    
}

- (IBAction)payInterswitch:(id)sender;
- (IBAction)payBank:(id)sender;
- (IBAction)payInapp:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *level2Button;
@property (strong, nonatomic) CPInterswitchPaymentViewController *purchaseController;
-(void)enableLevel2;
@end
