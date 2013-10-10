//
//  CPGroupViewController.m
//  ChitPay
//
//  Created by Armia on 17/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPGroupViewController.h"

#import "CPProductsViewController.h"

#import "CPNotificationListViewController.h"

#import "CPFavouritesViewController.h"

#import "CPSettingsViewController.h"

@interface CPGroupViewController ()
{
    NSArray *menuList;
    NSMutableArray *keyList;
    NSMutableDictionary *dict;
}

@end

@implementation CPGroupViewController

@synthesize menuTable,groupId;

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
        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chit.png"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://chitbox247.com/pos/index.php/apiv2?model=services&group_id=%d&service_id=",groupId]]];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
	NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    menuList = [[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"];
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        keyList = [[NSMutableArray alloc]init];
        for(int i = 0; i< [[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] count];i++)
        {
            NSLog(@"INSERTING %@",[[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] objectAtIndex:i]objectForKey:@"provider_name"]objectForKey:@"text"]);
            if(![keyList containsObject:[[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] objectAtIndex:i]objectForKey:@"provider_name"]objectForKey:@"text"]])
            {
                [keyList addObject:[[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] objectAtIndex:i]objectForKey:@"provider_name"]objectForKey:@"text"]];
                NSLog(@"SUCCESS");
            }
            else
            {
                NSLog(@"FAILED");
            }
        }
        NSLog(@"LIST %@",keyList);
        //NSLog(@"COMPLETE %@",[[dict objectForKey:@"AIRTEL"]objectForKey:@"service_name"]);
        [menuTable reloadData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Login Failure"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"Network error"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return keyList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    //NSLog(@"LOAD %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"provider_name"]objectForKey:@"text"]);
    //cell.textLabel.text = [[[menuList objectAtIndex:indexPath.row]objectForKey:@"provider_name"]objectForKey:@"text"];
    cell.textLabel.text = [keyList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    //NSLog(@"MENU %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"groupname"]objectForKey:@"name"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor dullBlueColor];
    cell.selectedBackgroundView = selectionColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"PRODUCTS");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *productList = [[NSMutableArray alloc]init];
    for(int i = 0; i<menuList.count; i++)
    {
        //NSLog(@"-> %@ %@",[[menuList objectAtIndex:i]objectForKey:@"service_name"],[[menuList objectAtIndex:i]objectForKey:@"provider_name"]);
        NSString *providerName = [[[menuList objectAtIndex:i]objectForKey:@"provider_name"]objectForKey:@"text"];
        if([[keyList objectAtIndex:indexPath.row] isEqualToString:providerName])
        {
            NSLog(@"-> %@",[[[menuList objectAtIndex:i]objectForKey:@"service_name"]objectForKey:@"text"]);
            [productList addObject:[menuList objectAtIndex:i]];
        }
    }
    
    CPProductsViewController *productsViewController = [[CPProductsViewController alloc]initWithNibName:@"CPProductsViewController" bundle:nil];
    [productsViewController setMenuList:productList];
    [self.navigationController pushViewController:productsViewController animated:YES];
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
    [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor redColor]];
    alertView.animationDuration = 0.15;
    alertView.tag = 888;
    [alertView show];
}

@end
