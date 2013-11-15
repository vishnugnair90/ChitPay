//
//  CPMenuViewController.h
//  ChitPay
//
//  Created by Armia on 04/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "ChitPayViewController.h"

@interface CPMenuViewController : ChitPayViewController<UITableViewDataSource,UITableViewDelegate,RNFrostedSidebarDelegate>
{
    
}
@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, strong) IBOutlet UITableView *menuTable;
-(IBAction)pop:(id)sender;

@end
