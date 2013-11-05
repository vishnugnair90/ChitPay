//
//  CPProductsViewController.m
//  ChitPay
//
//  Created by Armia on 17/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPProductsViewController.h"

#import "CPFormViewController.h"

#import "CPSettingsViewController.h"

#import "CPNotificationListViewController.h"

#import "CPFavouritesViewController.h"

@interface CPProductsViewController ()

@end

@implementation CPProductsViewController

@synthesize menuList;

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
        
        [button2 addTarget:self action:@selector(onBurger:) forControlEvents:UIControlEventTouchUpInside];
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
    _menuTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile"]];
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
    //NSLog(@"LOAD %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"provider_name"]objectForKey:@"text"]);
    //cell.textLabel.text = [[[menuList objectAtIndex:indexPath.row]objectForKey:@"provider_name"]objectForKey:@"text"];
    cell.textLabel.text = [[[menuList objectAtIndex:indexPath.row]objectForKey:@"service_name"]objectForKey:@"text"];
    cell.textLabel.font = [UIFont fontWithName:@"LaoUI.ttf" size:20.0];
    //NSLog(@"MENU %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"groupname"]objectForKey:@"name"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor dullBlueColor];
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = selectionColor;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *array = [[NSArray alloc]init];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = [[[menuList objectAtIndex:indexPath.row]objectForKey:@"fields"]objectForKey:@"field"];
    NSLog(@"OBJECT %d",[[[[menuList objectAtIndex:indexPath.row]objectForKey:@"service_id"]objectForKey:@"text"] integerValue]);
    NSLog(@"FIELDS NUMBER %d",array.count);
    [SVProgressHUD show];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://chitbox247.com/pos/index.php/apiv2?model=services&group_id=&service_id=%d",[[[[menuList objectAtIndex:indexPath.row]objectForKey:@"service_id"]objectForKey:@"text"] integerValue]]]];
    [request setDelegate:self];
    [request startAsynchronous];
    /*
    if( [[[[menuList objectAtIndex:indexPath.row]objectForKey:@"fields"]objectForKey:@"field"] containsObject:@"char_count"])
    {
        NSLog(@"CHOICE 1");
        //array = [[menuList objectAtIndex:indexPath.row]objectForKey:@"fields"];
    }
    else
    {
        NSLog(@"CHOICE 2");
        //array = [[[menuList objectAtIndex:indexPath.row]objectForKey:@"fields"]objectForKey:@"field"];
    }
     */
    //NSLog(@"FIELDS %@",array);
    //NSLog(@"FIELD COUNT %d",array.count);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    
	NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        /*
        for(id key=@"field" in responseDictionary)
            NSLog(@"key=%@ value=%@", key, [[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"fields"] objectForKey:@"field"]);
         
         */
        
        /*
        @try
        {
            [[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"fields"] objectForKey:@"field"]objectForKey:@"field_id"];
            
            NSLog(@"PASS");
        }
        @catch (NSException *exception)
        {
            NSLog(@"CRASH");
        }
         */
         
        
        
        NSLog(@"RESULT %@",[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]);
        if([[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"fields"]objectForKey:@"field"] isKindOfClass:[NSArray class]])
        {
            NSLog(@"ARRAY");
            NSArray *array = [[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"fields"]objectForKey:@"field"];
            for(NSDictionary *dict in array)
            {
                NSLog(@"%@",[[dict objectForKey:@"field_name"]objectForKey:@"text"]);
            }
            CPFormViewController *formViewController = [[CPFormViewController alloc]initWithNibName:@"CPFormViewController" bundle:Nil];
            [formViewController setFieldsArray:array];
            int mode = [[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] objectForKey:@"mode"]objectForKey:@"text" ] integerValue];
            int type = [[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] objectForKey:@"type"]objectForKey:@"text" ] integerValue];
            int service_id = [[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] objectForKey:@"service_id"]objectForKey:@"text" ] integerValue];
            [formViewController setMode:mode];
            [formViewController setType:type];
            [formViewController setService_id:service_id];
            [formViewController setCost:[NSString stringWithFormat:@"%@",[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"cost"]objectForKey:@"text"]]];
            NSLog(@"COST %@",[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"cost"]objectForKey:@"text"]);
            [self.navigationController pushViewController:formViewController animated:YES];
        }
        else if([[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"fields"]objectForKey:@"field"] isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"DICTIONARY");
            NSLog(@"%@",[[[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"fields"]objectForKey:@"field"] objectForKey:@"field_name"]objectForKey:@"text"]);
            
            CPFormViewController *formViewController = [[CPFormViewController alloc]initWithNibName:@"CPFormViewController" bundle:Nil];
            [formViewController setFieldsArray:[NSArray arrayWithObject:[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"fields"]objectForKey:@"field"]]];
            int mode = [[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] objectForKey:@"mode"]objectForKey:@"text" ] integerValue];
            int type = [[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] objectForKey:@"type"]objectForKey:@"text" ] integerValue];
            int service_id = [[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] objectForKey:@"service_id"]objectForKey:@"text" ] integerValue];
            NSLog(@"SERVICE ID IS SET %d FROM %d",service_id,[[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"] objectForKey:@"service_id"]objectForKey:@"text" ] integerValue]);
            [formViewController setMode:mode];
            [formViewController setType:type];
            [formViewController setService_id:service_id];
            [formViewController setCost:[NSString stringWithFormat:@"%@",[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"cost"]objectForKey:@"text"]]];
            NSLog(@"COST %@",[[[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"cost"]objectForKey:@"text"]);
            [self.navigationController pushViewController:formViewController animated:YES];
            
        }
        else
        {
            NSLog(@"OTHER");
        }
        /*
        NSArray *array = [[NSArray alloc]init];
        @try
        {
            array = [[[[responseDictionary objectForKey:@"response"]objectForKey:@"services"]objectForKey:@"service"]objectForKey:@"fields"];
        }
        @catch (NSException *exception)
        {
            NSLog(@"FAILED %d",array.count);
        }
        @finally
        {
            NSLog(@"SUCCESS %d",array.count);
        }
         */
        [SVProgressHUD dismiss];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Login Failure"];
        [SVProgressHUD dismiss];
    }
}

-(IBAction)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"gear"],
                        [UIImage imageNamed:@"globe"],
                        [UIImage imageNamed:@"profile"],
                        [UIImage imageNamed:@"star"],
                        [UIImage imageNamed:@"gear"],
                        [UIImage imageNamed:@"globe"],
                        [UIImage imageNamed:@"profile"],
                        [UIImage imageNamed:@"star"],
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        ];
    NSArray *titles = @[
                        @"HOME",
                        @"PROFILE",
                        @"BALANCE",
                        @"FUND TRANSFER",
                        @"NOTIFICATIONS",
                        @"STATEMENT",
                        @"TRANSACTIONS",
                        @"LOGOUT",
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:Nil borderColors:colors titleTexts:titles];
    //RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:Nil borderColors:colors];
    //RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    callout.isSingleSelect = YES;
    //  callout.showFromRight = YES;
    callout.tintColor = [UIColor colorWithWhite:0.5 alpha:0.55];
    [callout show];
}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    [sidebar dismissAnimated:YES];
    NSLog(@"Tapped item at index %i",index);
    switch (index) {
        case 0:
        {
            NSLog(@"HOME");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"PROFILE");
            CPProfileViewController *ProfileViewController = [[CPProfileViewController alloc]initWithNibName:@"CPProfileViewController" bundle:nil];
            [self.navigationController pushViewController:ProfileViewController animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"BALANCE");
            CPBalanceViewController *BalanceViewController = [[CPBalanceViewController alloc]initWithNibName:@"CPBalanceViewController" bundle:nil];
            [self.navigationController pushViewController:BalanceViewController animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"TRANSFER");
            CPTransferViewController *TransferViewController = [[CPTransferViewController alloc]initWithNibName:@"CPTransferViewController" bundle:nil];
            [self.navigationController pushViewController:TransferViewController animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"NOTIFICATIONS");
            CPNotificationListViewController *NotificationListViewController = [[CPNotificationListViewController alloc]initWithNibName:@"CPNotificationListViewController" bundle:nil];
            [self.navigationController pushViewController:NotificationListViewController animated:YES];
        }
            break;
        case 5:
        {
            NSLog(@"STATEMENT");
            CPStatementViewController *StatementViewController = [[CPStatementViewController alloc]initWithNibName:@"CPStatementViewController" bundle:nil];
            [self.navigationController pushViewController:StatementViewController animated:YES];
        }
            break;
        case 6:
        {
            NSLog(@"TRANSACTIONS");
            CPTransactionsViewController *TransactionsListViewController = [[CPTransactionsViewController alloc]initWithNibName:@"CPTransactionsViewController" bundle:nil];
            [self.navigationController pushViewController:TransactionsListViewController animated:YES];
        }
            break;
        case 7:
        {
            NSLog(@"LOGOUT");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"username"];
            [defaults removeObjectForKey:@"password"];
            [defaults removeObjectForKey:@"account_details"];
            [defaults synchronize];
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
            break;
        default:
            break;
    }
}


@end

