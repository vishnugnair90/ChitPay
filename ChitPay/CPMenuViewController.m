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

@interface CPMenuViewController ()

@end

@implementation CPMenuViewController

@synthesize menuList,menuTable;

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
    NSLog(@"DATA %@",[[menuList objectAtIndex:0]objectForKey:@"name"]);
    // Do any additional setup after loading the view from its nib.
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
    //NSLog(@"MENU %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"groupname"]objectForKey:@"name"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor dullBlueColor];
    cell.selectedBackgroundView = selectionColor;
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
@end
