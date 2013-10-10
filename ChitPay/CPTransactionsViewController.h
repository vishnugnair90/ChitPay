//
//  CPTransactionsViewController.h
//  ChitPay
//
//  Created by Armia on 10/10/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPTransactionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic, strong) NSArray *transactionsList;
@property (nonatomic, strong) IBOutlet UITableView *transactionTable;
- (IBAction)toggleFavoriteSwitch:(UISwitch *)switchView;
- (void)LoadTransactionData;
@end
