//
//  CPHomeViewController.h
//  ChitPay
//
//  Created by Armia on 04/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "ChitPayViewController.h"

@interface CPHomeViewController : ChitPayViewController<UITableViewDataSource,UITableViewDelegate,RNFrostedSidebarDelegate>
{
    NSArray *menuListArray;
}
@property (nonatomic, strong) IBOutlet UITableView *menuTable;
@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;
-(void)pop:(id)sender;
-(void)logout:(id)sender;
-(void)showNotifications;
-(void)showFavourites;
-(void)showShareMenu;
-(void)showSettings;
@end
