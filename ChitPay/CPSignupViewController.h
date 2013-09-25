//
//  CPSignupViewController.h
//  ChitPay
//
//  Created by Armia on 05/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSignupViewController : UIViewController<UITextFieldDelegate>
{
    
}

@property (nonatomic, strong) IBOutlet UITextField *txtEmail;
@property (nonatomic, strong) IBOutlet UITextField *txtUsername;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword1;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword2;

-(IBAction)next:(id)sender;
-(IBAction)cancel:(id)sender;
-(BOOL)checkFields;
@end
