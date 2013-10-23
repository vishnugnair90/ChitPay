//
//  CPProfileEditViewController.h
//  ChitPay
//
//  Created by Armia on 10/21/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPProfileEditViewController : UIViewController
{
    
}
@property IBOutlet UITextField *Name;
@property IBOutlet UITextField *Email;
@property IBOutlet UITextField *Phone1;
@property IBOutlet UITextField *Phone2;
@property IBOutlet UITextField *City;
@property IBOutlet UITextField *State;
@property IBOutlet UITextField *Address;

@property NSString *strName;
@property NSString *strEmail;
@property NSString *strPhone1;
@property NSString *strPhone2;
@property NSString *strCity;
@property NSString *strState;
@property NSString *strAddress;

-(IBAction)submit:(id)sender;
@end
