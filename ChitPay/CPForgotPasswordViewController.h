//
//  CPForgotPasswordViewController.h
//  ChitPay
//
//  Created by Armia on 06/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPForgotPasswordViewController : UIViewController<UITextFieldDelegate>
{
    
}
@property (nonatomic, strong) IBOutlet UITextField *txtUsername;
@property (nonatomic, strong) IBOutlet UITextField *txtEmail;
-(IBAction)submit:(id)sender;
-(IBAction)cancel:(id)sender;
@end
