//
//  CPPasswordViewController.h
//  ChitPay
//
//  Created by Armia on 10/21/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPPasswordViewController : UIViewController
{
    
}
@property IBOutlet UITextField *txtOldPassword;
@property IBOutlet UITextField *txtNewPassword1;
@property IBOutlet UITextField *txtNewPassword2;
@property IBOutlet UILabel *accountNumber;

- (IBAction)submit:(id)sender;
@end
