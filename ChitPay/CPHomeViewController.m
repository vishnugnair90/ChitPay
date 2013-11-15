//
//  CPHomeViewController.m
//  ChitPay
//
//  Created by Armia on 04/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPHomeViewController.h"

#import "CPWelcomeViewController.h"

#import "CPAppDelegate.h"

#import "CPMenuViewController.h"

#import "CPGroupViewController.h"

#import "CPNotificationListViewController.h"

#import "CPFavouritesViewController.h"

#import "CPSettingsViewController.h"

#import "CPProfileViewController.h"

#import "CPBalanceViewController.h"

#import "CPTransferViewController.h"

#import "CPStatementViewController.h"

#import "CPTransactionsViewController.h"



@interface CPHomeViewController ()<FUIAlertViewDelegate>
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) UIToolbar *toolbar;
@end

@implementation CPHomeViewController

@synthesize menuTable,welcomeLabel,toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //menuTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tile"]];
    menuTable.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chit.png"]];
    //[self.navigationController.navigationBar setHidden:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [welcomeLabel setText:[NSString stringWithFormat:@"Welcome %@",[[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"contacts"]objectForKey:@"contact_name"]objectForKey:@"text"]]];
    self.navigationController.navigationBar.translucent = NO;
    //NSLog(@"DATA %@",[defaults objectForKey:@"username"]);
    // Do any additional setup after loading the view from its nib.
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"notification_count"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    welcomeLabel.font = [UIFont fontWithName:@"LaoUI.ttf" size:welcomeLabel.font.pointSize];
    UISwipeGestureRecognizer * Swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onBurger:)];
    Swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:Swipeleft];
}

- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?model=menu",[defaults objectForKey:@"server"]]]];
    [request setDelegate:self];
    [request startAsynchronous];
    [[CPNotificationHandler singleton]getNotificaton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pop:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)logout:(id)sender
{
    CPWelcomeViewController *welcomeViewController = [[CPWelcomeViewController alloc]initWithNibName:@"CPWelcomeViewController" bundle:nil];
    CPAppDelegate *appDelegate = (CPAppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *appNavigationController = [[UINavigationController alloc]initWithRootViewController:welcomeViewController];
    //self.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //self.navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:appNavigationController
                                            animated:YES
                                          completion:^{
                                              
                                              appDelegate.window.rootViewController = appNavigationController;

                                              
                                          }];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    
	NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        menuListArray = [[[[responseDictionary objectForKey:@"response"]objectForKey:@"menu"]objectForKey:@"groups"]objectForKey:@"group"];
        //NSLog(@"DATA %@",menuListArray);
        [menuTable reloadData];
        [SVProgressHUD dismiss];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Login Failure"];
        [SVProgressHUD dismiss];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"Network error"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuListArray.count;
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
    cell.textLabel.text = [[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"name"]objectForKey:@"text"];
    cell.textLabel.font = [UIFont fontWithName:@"LaoUI.ttf" size:20.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //NSLog(@"MENU %@",[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"name"]objectForKey:@"text"]);
    cell.backgroundColor = [UIColor yellowColor];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg"]];
    cell.selectedBackgroundView = selectionColor;
    cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundView.frame = CGRectMake(cell.backgroundView.frame.origin.x+10, cell.backgroundView.frame.origin.y+10, cell.backgroundView.frame.size.width-20, cell.backgroundView.frame.size.height-20);
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
    //NSLog(@"MENU %@",[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPMenuViewController *menuViewController = [[CPMenuViewController alloc]initWithNibName:@"CPMenuViewController" bundle:nil];
    NSArray *array = [NSArray alloc];
    if([[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"]valueForKey:@"id"] != Nil)
    {
        NSLog(@"SERVICE");
        NSLog(@"DATA %@",[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"]);
        NSArray *countarray = [[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"]valueForKey:@"subgroups"];
        if(countarray.count >1)
        {
            NSLog(@"MULTI");
            [menuViewController setMenuList:[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"]];
            //array = [[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"];
            //NSLog(@"DATA %@",[[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"]valueForKey:@"subgroups"]);
            //menuListArray = [[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"]valueForKey:@"subgroups"];
        }
        else
        {
            NSLog(@"SINGLE %@",[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"]);
            NSArray *array = [[NSArray alloc]initWithObjects:[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"], nil];
            [menuViewController setMenuList:array];
            //array = [[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"];
        }
        //array = [[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"];
        [self.navigationController pushViewController:menuViewController animated:YES];
    }
    else
    {
        NSLog(@"PROVIDER %@",[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"id"]objectForKey:@"text"]);
        
        CPGroupViewController *groupViewController = [[CPGroupViewController alloc]initWithNibName:@"CPGroupViewController" bundle:nil];
        int groupId = [[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"id"]objectForKey:@"text"] integerValue];
        NSLog(@"GROUP ID %d",groupId);
        [groupViewController setGroupId:groupId];
        [self.navigationController pushViewController:groupViewController animated:YES];
        
        
        
        //array = [[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"];
    }
    //NSLog(@"SELECTED %d \n\n%@",array.count,[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]);
    /*
    if([[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"])
    {
        [menuViewController setMenuList:[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"subgroups"]objectForKey:@"subgroup"]];
    }
    else
    {
        NSLog(@"SELECTED %@",[menuListArray objectAtIndex:indexPath.row]);
    }
     */
    
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

