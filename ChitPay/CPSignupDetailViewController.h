//
//  CPSignupDetailViewController.h
//  ChitPay
//
//  Created by Armia on 05/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSignupDetailViewController : UIViewController<UITextFieldDelegate>
{
    
}
@property (nonatomic, strong) IBOutlet UITextField *txtFirstName;
@property (nonatomic, strong) IBOutlet UITextField *txtLastName;
@property (nonatomic, strong) IBOutlet UITextField *txtPhone1;
@property (nonatomic, strong) IBOutlet UITextField *txtPhone2;
@property (nonatomic, strong) IBOutlet UITextField *txtStreet1;
@property (nonatomic, strong) IBOutlet UITextField *txtStreet2;
@property (nonatomic, strong) IBOutlet UITextField *txtCity;
@property (nonatomic, strong) IBOutlet UITextField *txtState;

@property (nonatomic, strong) NSString *strEmail;
@property (nonatomic, strong) NSString *strUsername;
@property (nonatomic, strong) NSString *strPassword;

-(IBAction)signup:(id)sender;
-(IBAction)cancel:(id)sender;
-(BOOL)checkFields;
@end
