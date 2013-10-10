//
//  CPStatementViewController.h
//  ChitPay
//
//  Created by Armia on 10/10/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPStatementViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic, strong) NSArray *statementList;
@property (nonatomic, strong) IBOutlet UITableView *statementTable;
- (IBAction)toggleFavoriteSwitch:(UISwitch *)switchView;
- (void)LoadTransactionData;

@end
