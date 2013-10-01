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


@interface CPHomeViewController ()

@end

@implementation CPHomeViewController

@synthesize menuTable;

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
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [TestFlight passCheckpoint:@"HOME START"];
    //[self.navigationController.navigationBar setHidden:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSLog(@"DATA %@",[defaults objectForKey:@"username"]);
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD show];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2?model=menu"]];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)logout:(id)sender
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
@end
