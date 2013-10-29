//
//  CPTransactionsViewController.m
//  ChitPay
//
//  Created by Armia on 10/10/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPTransactionsViewController.h"

#import "FlatUIKit.h"

@interface CPTransactionsViewController ()

@end

@implementation CPTransactionsViewController

@synthesize transactionsList,transactionTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage = [UIImage imageNamed:@"share.png"];
        
        [button setBackgroundImage:backButtonImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showShareMenu) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(0, 0, 30, 30);
        //________________________________________________________________________________________________________
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage1 = [UIImage imageNamed:@"fav.png"];
        
        [button1 setBackgroundImage:backButtonImage1 forState:UIControlStateNormal];
        
        [button1 addTarget:self action:@selector(showFavourites) forControlEvents:UIControlEventTouchUpInside];
        button1.frame = CGRectMake(0, 0, 30, 30);
        //________________________________________________________________________________________________________
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage2 = [UIImage imageNamed:@"settings.png"];
        
        [button2 setBackgroundImage:backButtonImage2 forState:UIControlStateNormal];
        
        [button2 addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
        button2.frame = CGRectMake(0, 0, 30, 30);
        
        //________________________________________________________________________________________________________
        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage3 = [UIImage imageWithColor:[UIColor orangeColor] cornerRadius:3.0];
        
        [button3 setBackgroundImage:backButtonImage3 forState:UIControlStateNormal];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [button3 setTitle:[NSString stringWithFormat:@"%@",[defaults objectForKey:@"notification_count"]] forState:UIControlStateNormal];
        
        [button3 addTarget:self action:@selector(showNotifications) forControlEvents:UIControlEventTouchUpInside];
        
        [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button3.frame = CGRectMake(0, 0, 30, 30);
        
        //________________________________________________________________________________________________________
        
        
        UIBarButtonItem *btnNotifications = [[UIBarButtonItem alloc] initWithCustomView:button3];
        btnNotifications.tintColor = [UIColor yellowColor];
        UIBarButtonItem *btnSharing = [[UIBarButtonItem alloc] initWithCustomView:button];
        btnSharing.tintColor = [UIColor greenColor];
        UIBarButtonItem *btnFavourites = [[UIBarButtonItem alloc] initWithCustomView:button1];
        btnFavourites.tintColor = [UIColor redColor];
        UIBarButtonItem *btnSetting = [[UIBarButtonItem alloc] initWithCustomView:button2];
        btnSetting.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:btnSetting,btnFavourites,btnSharing,btnNotifications, nil];
        
        UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage4 = [UIImage imageNamed:@"Home_logo@2x.png"];
        [button4 addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
        [button4 setBackgroundImage:backButtonImage4 forState:UIControlStateNormal];
        
        button4.frame = CGRectMake(0, 0, 100, 40);
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button4];
        
        self.navigationItem.leftBarButtonItems =[NSArray arrayWithObjects:barButtonItem, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadTransactionData];
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
    return transactionsList.count;
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    switchView.tag = indexPath.row;
    [switchView addTarget:self action:@selector(toggleFavoriteSwitch:) forControlEvents:UIControlEventValueChanged];
    NSString *account_no = [[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"];
    if([[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"sender_account"]objectForKey:@"text"] isEqualToString:account_no])
    {
        if([[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"sender_notification"]objectForKey:@"text"] isEqualToString:@"ON"])
        {
            [switchView setOn:YES animated:YES];
        }
        else
        {
            [switchView setOn:NO animated:YES];
        }
    }
    else
    {
        if([[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"receiver_notification"]objectForKey:@"text"] isEqualToString:@"ON"])
        {
            [switchView setOn:YES animated:YES];
        }
        else
        {
            [switchView setOn:NO animated:YES];
        }
    }
    /*
    cell.textLabel.text = [[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"transaction_id"]objectForKey:@"text"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.detailTextLabel.numberOfLines = 5;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%-30s\n%-20s", [[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"amount"]objectForKey:@"text"] UTF8String],[[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"status"]objectForKey:@"text"]UTF8String]];
    */
    
    cell.textLabel.text = [[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"transaction_id"]objectForKey:@"text"];
    cell.textLabel.font = [UIFont fontWithName:@"LaoUI.ttf" size:15.0];
    cell.detailTextLabel.numberOfLines =3;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"\t\t\t\t\AMOUNT %-20s\n\t\t\t\t\STATUS %-20s", [[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"amount"]objectForKey:@"text"] UTF8String],[[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"status"]objectForKey:@"text"]UTF8String]];
    
    //NSLog(@"MENU %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"groupname"]objectForKey:@"name"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor dullBlueColor];
    cell.selectedBackgroundView = selectionColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *array = [[NSArray alloc]init];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"transaction_id"]objectForKey:@"text"] message:[NSString stringWithFormat:@"Amount:%@\n\nSender:%@\n\nAccount:%@\n\nSender Notification:%@\n\nReceiver Notification:%@\n\nStatus:%@",[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"amount"]objectForKey:@"text"],[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"sender"]objectForKey:@"text"],[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"sender_account"]objectForKey:@"text"],[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"sender_notification"]objectForKey:@"text"],[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"receiver_notification"]objectForKey:@"text"],[[[transactionsList objectAtIndex:indexPath.row]objectForKey:@"status"]objectForKey:@"text"]] delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:@"", nil];
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
    NSLog(@"TRANSACTIONS %@",responseDictionary);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        if([[request.userInfo objectForKey:@"ACTION"] isEqualToString:@"CHANGESTATUS"])
        {
            [self LoadTransactionData];
        }
        else
        {
            NSString *receivedString = [request responseString];
            NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
            
            if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
            {
                
                transactionsList = [[[responseDictionary objectForKey:@"response"]objectForKey:@"records"]objectForKey:@"transaction"];
                NSLog(@"ARRAY %@",transactionsList);
                [SVProgressHUD dismiss];
                [transactionTable reloadData];
            }
        }
        
    }
    else
        NSLog(@"FAILED");
}
- (IBAction)toggleFavoriteSwitch:(UISwitch *)switchView
{
    UITableViewCell *cell = [transactionTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:switchView.tag inSection:0]];
    if(![switchView isOn])
    {
        //cell.textLabel.text = [NSString stringWithFormat:@"OFF"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
        [request setDelegate:self];
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<request method=\"notification.update\">"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<notification>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<unique_id>%@</unique_id>",[[[transactionsList objectAtIndex:switchView.tag]objectForKey:@"unique_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
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
        //cell.textLabel.text = [NSString stringWithFormat:@"OFF"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
        [request setDelegate:self];
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"<request method=\"notification.update\">"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<notification>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<unique_id>%@</unique_id>",[[[transactionsList objectAtIndex:switchView.tag]objectForKey:@"unique_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"<status>ON</status>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</notification>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setPostBody:postBody];
        [request setUserInfo:[NSDictionary dictionaryWithObject:@"CHANGESTATUS" forKey:@"ACTION"]];
        [SVProgressHUD show];
        NSLog(@"%@",request.requestHeaders);
        [request startAsynchronous];
    }
    //[self updateFavoriteInUserDefaultsFor:cell.textLabel.text withValue:[switchView isOn]];
}
- (void)LoadTransactionData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"transaction.list\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<transaction>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<search>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<trans_id></trans_id>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<trans_status></trans_status>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<from></from>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<to></to>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</search>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<page></page>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<per_page>56</per_page>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</transaction>"] dataUsingEncoding:NSUTF8StringEncoding]];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
