//
//  CPNotificationListViewController.m
//  ChitPay
//
//  Created by Armia on 10/4/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPNotificationListViewController.h"

#import "FlatUIKit.h"

@interface CPNotificationListViewController ()<FUIAlertViewDelegate>

@end

@implementation CPNotificationListViewController

@synthesize notificationList,notificationTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISwipeGestureRecognizer * Swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onBurger:)];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"notification_count"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    Swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:Swipeleft];
    [self LoadNotificationData];
    for(UITextField *field in [self.view subviews])
    {
        if([field isKindOfClass:[UITextField class]])
        {
            field.layer.borderWidth = kBorderWidth;
            field.layer.cornerRadius = kBorderCurve;
            field.font = [UIFont fontWithName:@"LaoUI.ttf" size:field.font.pointSize];
        }
    }
    for(UILabel *label in [self.view subviews])
    {
        if([label isKindOfClass:[UILabel class]])
        {
            //label.layer.borderWidth = kBorderWidth;
            //label.layer.cornerRadius = kBorderCurve;
            label.font = [UIFont fontWithName:@"LaoUI.ttf" size:label.font.pointSize];
        }
    }
    for(UIButton *button in [self.view subviews])
    {
        if([button isKindOfClass:[UIButton class]])
        {
            //label.layer.borderWidth = kBorderWidth;
            //label.layer.cornerRadius = kBorderCurve;
            button.titleLabel.font = [UIFont fontWithName:@"LaoUI.ttf" size:button.titleLabel.font.pointSize];
        }
    }

    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notificationList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    //NSLog(@"LOAD %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"provider_name"]objectForKey:@"text"]);
    //cell.textLabel.text = [[[menuList objectAtIndex:indexPath.row]objectForKey:@"provider_name"]objectForKey:@"text"];
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    switchView.tag = indexPath.row;
    [switchView addTarget:self action:@selector(toggleFavoriteSwitch:) forControlEvents:UIControlEventValueChanged];
    [switchView setOn:YES animated:YES];
    cell.textLabel.text = [[[notificationList objectAtIndex:indexPath.row]objectForKey:@"transaction_id"]objectForKey:@"text"];
    cell.textLabel.font = [UIFont fontWithName:@"LaoUI.ttf" size:15.0];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%-20s\n%-20s", [[[[notificationList objectAtIndex:indexPath.row]objectForKey:@"amount"]objectForKey:@"text"] UTF8String],[[[[notificationList objectAtIndex:indexPath.row]objectForKey:@"status"]objectForKey:@"text"]UTF8String]];
    
    //NSLog(@"MENU %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"groupname"]objectForKey:@"name"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg"]];    cell.selectedBackgroundView = selectionColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *array = [[NSArray alloc]init];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:[[[notificationList objectAtIndex:indexPath.row]objectForKey:@"transaction_id"]objectForKey:@"text"] message:[NSString stringWithFormat:@"Amount:%@\n\nSender:%@\n\nAccount:%@\n\nSender Notification:%@\n\nReceiver Notification:%@\n\nStatus:%@",[[[notificationList objectAtIndex:indexPath.row]objectForKey:@"amount"]objectForKey:@"text"],[[[notificationList objectAtIndex:indexPath.row]objectForKey:@"sender"]objectForKey:@"text"],[[[notificationList objectAtIndex:indexPath.row]objectForKey:@"sender_account"]objectForKey:@"text"],[[[notificationList objectAtIndex:indexPath.row]objectForKey:@"sender_notification"]objectForKey:@"text"],[[[notificationList objectAtIndex:indexPath.row]objectForKey:@"receiver_notification"]objectForKey:@"text"],[[[notificationList objectAtIndex:indexPath.row]objectForKey:@"status"]objectForKey:@"text"]] delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:@"", nil];
    alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    alertView.defaultButtonColor = [UIColor midnightBlueColor];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonShadowColor = [UIColor clearColor];
    alertView.defaultButtonColor = [UIColor clearColor];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    [alertView.titleLabel setFont:[UIFont fontWithName:@"LaoUI.ttf" size:20.0]];
    [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor dullBlueColor]];
    alertView.animationDuration = 0.15;
    alertView.tag = 999;
    [alertView show];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [SVProgressHUD dismiss];
    
    NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"%@",responseDictionary);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        if([[request.userInfo objectForKey:@"ACTION"] isEqualToString:@"CHANGESTATUS"])
        {
            [self LoadNotificationData];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[[[responseDictionary objectForKey:@"response"] objectForKey:@"total_records"] objectForKey:@"text"] forKey:@"notification_count"];
            [defaults synchronize];
        }
        else
        {
            NSString *receivedString = [request responseString];
            NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
            
            if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
            {
                
                notificationList = [[[responseDictionary objectForKey:@"response"]objectForKey:@"records"]objectForKey:@"notification"];
                NSLog(@"ARRAY %@",notificationList);
                [SVProgressHUD dismiss];
                [notificationTable reloadData];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[[[responseDictionary objectForKey:@"response"] objectForKey:@"total_records"] objectForKey:@"text"] forKey:@"notification_count"];
                [defaults synchronize];
            }
        }

    }
    else
        NSLog(@"FAILED");
}
- (IBAction)toggleFavoriteSwitch:(UISwitch *)switchView
{
    UITableViewCell *cell = [notificationTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:switchView.tag inSection:0]];
    if(![switchView isOn])
    {
        //cell.textLabel.text = [NSString stringWithFormat:@"OFF"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
        [request setDelegate:self];
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<request method=\"notification.update\">"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<notification>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<unique_id>%@</unique_id>",[[[notificationList objectAtIndex:switchView.tag]objectForKey:@"unique_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<status>OFF</status>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</notification>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setPostBody:postBody];
        [request setUserInfo:[NSDictionary dictionaryWithObject:@"CHANGESTATUS" forKey:@"ACTION"]];
        [SVProgressHUD show];
        NSLog(@"%@",request.requestHeaders);
        [request startAsynchronous];
    }
    else
    {
        //cell.textLabel.text = [NSString stringWithFormat:@"ON"];
    }
    //[self updateFavoriteInUserDefaultsFor:cell.textLabel.text withValue:[switchView isOn]];
}
- (void)LoadNotificationData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"notification.list\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<notification>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<pin>%d</pin>",1234] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</notification>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
    [SVProgressHUD show];
    [request startAsynchronous];
}

- (void)showNotifications
{
    CPNotificationListViewController *NotificationListViewController = [[CPNotificationListViewController alloc]initWithNibName:@"CPNotificationListViewController" bundle:nil];
    [self.navigationController pushViewController:NotificationListViewController animated:YES];
}

- (void)showFavourites
{
    CPFavouritesViewController *FavouritesViewController = [[CPFavouritesViewController alloc]initWithNibName:@"CPFavouritesViewController" bundle:nil];
    [self.navigationController pushViewController:FavouritesViewController animated:YES];
}

- (void)showSettings
{
    CPSettingsViewController *SettingsViewController = [[CPSettingsViewController alloc]initWithNibName:@"CPSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:SettingsViewController animated:YES];
}

- (void)showShareMenu
{
    FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"Share to" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Facebook",@"Google+",@"LinkedIn",@"Twitter", nil];
    alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    alertView.defaultButtonColor = [UIColor midnightBlueColor];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonShadowColor = [UIColor clearColor];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    [alertView.titleLabel setFont:[UIFont fontWithName:@"LaoUI.ttf" size:20.0]];
    [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor redColor]];
    alertView.animationDuration = 0.15;
    alertView.tag = 888;
    [alertView show];
}
-(void)pop:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context
{
    if([keyPath isEqual:@"notification_count"])
    {
        NSLog(@"SomeKey change: %@", change);
        UIBarButtonItem *btnBar = [self.navigationItem.rightBarButtonItems objectAtIndex:3];
        UIButton *btn = (UIButton *)btnBar.customView;
        [btn setTitle:[NSString stringWithFormat:@"%@",[change objectForKey:@"new"]] forState:UIControlStateNormal];
    }
}

@end
