//
//  CPMenuViewController.h
//  ChitPay
//
//  Created by Armia on 04/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, strong) IBOutlet UITableView *menuTable;
-(IBAction)pop:(id)sender;

@end
