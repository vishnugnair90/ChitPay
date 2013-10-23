//
//  CPPINViewController.h
//  ChitPay
//
//  Created by Armia on 10/21/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPPINViewController : UIViewController
{
    
}
@property IBOutlet UITextField *txtOldPIN;
@property IBOutlet UITextField *txtNewPIN1;
@property IBOutlet UITextField *txtNewPIN2;
@property IBOutlet UILabel *accountNumber;

- (IBAction)resetPIN:(id)sender;
- (IBAction)submit:(id)sender;
@end
