//
//  CPHomeViewController.h
//  ChitPay
//
//  Created by Armia on 04/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *menuListArray;
}
@property (nonatomic, strong) IBOutlet UITableView *menuTable;
-(IBAction)pop:(id)sender;
-(IBAction)logout:(id)sender;
@end
