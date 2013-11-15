//
//  CPGroupViewController.h
//  ChitPay
//
//  Created by Armia on 17/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPGroupViewController : ChitPayViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic) int groupId;
@property (nonatomic, strong) IBOutlet UITableView *menuTable;
-(IBAction)pop:(id)sender;
@end
