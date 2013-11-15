//
//  CPMenuViewController.m
//  ChitPay
//
//  Created by Armia on 04/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPMenuViewController.h"

#import "CPGroupViewController.h"

#import "CPServiceViewController.h"

#import "CPSettingsViewController.h"

#import "CPNotificationListViewController.h"

#import "CPFavouritesViewController.h"


@interface CPMenuViewController ()

@end

@implementation CPMenuViewController

@synthesize menuList,menuTable;

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
    //menuTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile"]];
    NSLog(@"DATA %@",[[menuList objectAtIndex:0]objectForKey:@"name"]);
    UISwipeGestureRecognizer * Swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onBurger:)];
    Swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:Swipeleft];
        //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chit.png"]];
    // Do any additional setup after loading the view from its nib.
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
    
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        //menuListArray = [[[[responseDictionary objectForKey:@"response"]objectForKey:@"menu"]objectForKey:@"groups"]objectForKey:@"group"];
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
    return menuList.count;
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
    cell.textLabel.text = [[[menuList objectAtIndex:indexPath.row]objectForKey:@"name"]objectForKey:@"text"];
    cell.textLabel.font = [UIFont fontWithName:@"LaoUI.ttf" size:20.0];
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //NSLog(@"MENU %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"groupname"]objectForKey:@"name"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg"]];
    cell.selectedBackgroundView = selectionColor;
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row % 2)
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"selected %@",[menuList objectAtIndex:indexPath.row]);
    if([[[[menuList objectAtIndex:indexPath.row]objectForKey:@"type"] objectForKey:@"text"]isEqualToString:@"group"])
    {
        NSLog(@"GROUP");
        CPGroupViewController *groupViewController = [[CPGroupViewController alloc]initWithNibName:@"CPGroupViewController" bundle:nil];
        int groupId = [[[[menuList objectAtIndex:indexPath.row]objectForKey:@"id"] objectForKey:@"text"] integerValue];
        NSLog(@"GROUP ID %d",groupId);
        [groupViewController setGroupId:groupId];
        [self.navigationController pushViewController:groupViewController animated:YES];
    }
    else
    {
        NSLog(@"SERVICE");
        CPGroupViewController *groupViewController = [[CPGroupViewController alloc]initWithNibName:@"CPGroupViewController" bundle:nil];
        int groupId = [[[[menuList objectAtIndex:indexPath.row]objectForKey:@"top"] objectForKey:@"text"] integerValue];
        NSLog(@"GROUP ID %d",groupId);
        [groupViewController setGroupId:groupId];
        [self.navigationController pushViewController:groupViewController animated:YES];
        //array = [[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"];
    }
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
