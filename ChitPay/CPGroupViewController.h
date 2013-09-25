//
//  CPGroupViewController.h
//  ChitPay
//
//  Created by Armia on 17/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic) int groupId;
@property (nonatomic, strong) IBOutlet UITableView *menuTable;
-(IBAction)pop:(id)sender;
@end
