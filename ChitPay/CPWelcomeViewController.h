//
//  CPWelcomeViewController.h
//  ChitPay
//
//  Created by Armia on 04/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPWelcomeViewController : UIViewController<UITextFieldDelegate>
{
    
}
@property (nonatomic, strong) IBOutlet UIButton *btnLogin;
@property (nonatomic, strong) IBOutlet UIButton *btnSignup;
@property (nonatomic, strong) IBOutlet UIButton *btnForgotpass;
@property (nonatomic, strong) IBOutlet UIButton *btnChooseCountry;
@property (nonatomic, strong) IBOutlet UITextField *txtUsername;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UILabel *orLabel;

-(IBAction)login:(id)sender;
-(IBAction)signup:(id)sender;
-(IBAction)forgot:(id)sender;
-(IBAction)chooseCountry:(id)sender;
@end
