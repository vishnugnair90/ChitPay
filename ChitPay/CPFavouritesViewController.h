//
//  CPFavouritesViewController.h
//  ChitPay
//
//  Created by Armia on 10/4/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPFavouritesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic, strong) NSArray *favouritesList;
@property (nonatomic, strong) IBOutlet UITableView *favouritesTable;

@end
