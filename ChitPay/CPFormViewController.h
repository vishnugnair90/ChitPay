//
//  CPFormViewController.h
//  ChitPay
//
//  Created by Armia on 23/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPFormViewController : UIViewController<UITextFieldDelegate>
{
    
}
@property (nonatomic, strong) NSArray *fieldsArray;
@property int mode;
@property int type;
@property int service_id;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) IBOutlet UITableView *menuTable;
-(IBAction)pop:(id)sender;
-(IBAction)submit:(id)sender;
@end
