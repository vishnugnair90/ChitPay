//
//  CPProfileViewController.h
//  ChitPay
//
//  Created by Armia on 10/10/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPProfileViewController : UIViewController
{
    
}
@property IBOutlet UILabel *lblName;
@property IBOutlet UILabel *lblaccountID;
@property IBOutlet UILabel *lblemail;
@property IBOutlet UILabel *lbladdress;
@property IBOutlet UILabel *lblphone1;
@property IBOutlet UILabel *lblphone2;
@property IBOutlet UILabel *lblcity;
@property IBOutlet UILabel *lblstate;

-(IBAction)editAction:(id)sender;
-(IBAction)passwordAction:(id)sender;
-(IBAction)pinAction:(id)sender;
@end
