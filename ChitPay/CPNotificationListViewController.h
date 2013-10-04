//
//  CPNotificationListViewController.h
//  ChitPay
//
//  Created by Armia on 10/4/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPNotificationListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic, strong) NSArray *notificationList;
@property (nonatomic, strong) IBOutlet UITableView *notificationTable;
@end
