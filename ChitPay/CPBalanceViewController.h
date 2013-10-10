//
//  CPBalanceViewController.h
//  ChitPay
//
//  Created by Armia on 10/10/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBalanceViewController : UIViewController
{
    
}
@property IBOutlet UILabel *lblName;
@property IBOutlet UILabel *lblaccountID;
@property IBOutlet UILabel *lblBalance;

-(IBAction)transferFundsAction:(id)sender;
-(IBAction)transactionStatementAction:(id)sender;
-(IBAction)rechargeAccountAction:(id)sender;
@end
