//
//  CPTransferViewController.h
//  ChitPay
//
//  Created by Armia on 10/17/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPTransferViewController : UIViewController<FUIAlertViewDelegate,UITextFieldDelegate>
{
    
}
@property IBOutlet UITextField *txtAccountNo;
@property IBOutlet UITextField *txtAmount;
@property IBOutlet UITextField *txtComment;
@property IBOutlet UILabel *lblName;
-(IBAction)ProceedAction:(id)sender;
-(IBAction)ValidateAccountAction:(id)sender;
-(void)Submit:(id)sender;
@end
