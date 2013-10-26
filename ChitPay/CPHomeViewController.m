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

@interface CPHomeViewController ()<FUIAlertViewDelegate>

@end

@implementation CPHomeViewController

@synthesize menuTable,welcomeLabel;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2?model=menu"]];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //NSLog(@"MENU %@",[[[menuListArray objectAtIndex:indexPath.row]objectForKey:@"name"]objectForKey:@"text"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor dullBlueColor];
    cell.selectedBackgroundView = selectionColor;
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
