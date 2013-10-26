//
//  CPInterswitchPaymentViewController.h
//  ChitPay
//
//  Created by Armia on 10/24/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PayPalMobile.h"

@interface CPInterswitchPaymentViewController : UIViewController<UIWebViewDelegate,PayPalPaymentDelegate>
{
    
}
@property IBOutlet UIWebView *paymentWebView;
@end
