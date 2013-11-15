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
       
        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    menuTable.backgroundColor = [UIColor clearColor];
    UISwipeGestureRecognizer * Swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onBurger:)];
    Swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:Swipeleft];
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chit.png"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?model=services&group_id=%d&service_id=",[defaults objectForKey:@"server"],groupId]]];
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
    cell.textLabel.font = [UIFont fontWithName:@"LaoUI" size:20.0];
    //NSLog(@"MENU %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"groupname"]objectForKey:@"name"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg"]];
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = selectionColor;
    cell.backgroundColor = [UIColor clearColor];
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



@end
