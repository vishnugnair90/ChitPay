//
//  CPFavouritesViewController.m
//  ChitPay
//
//  Created by Armia on 10/4/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPFavouritesViewController.h"

#import "CPFormViewController.h"


@interface CPFavouritesViewController ()<FUIAlertViewDelegate>

@end

@implementation CPFavouritesViewController

@synthesize favouritesList,favouritesTable;

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"favourites.list\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
    [SVProgressHUD show];
    [request startAsynchronous];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return favouritesList.count;
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
    cell.textLabel.text = [[[favouritesList objectAtIndex:indexPath.row]objectForKey:@"name"]objectForKey:@"text"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    //NSLog(@"MENU %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"groupname"]objectForKey:@"name"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor dullBlueColor];
    cell.selectedBackgroundView = selectionColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *array = [[NSArray alloc]init];
    [SVProgressHUD show];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://chitbox247.com/pos/index.php/apiv2?model=services&group_id=&service_id=%d",[[[[favouritesList objectAtIndex:indexPath.row]objectForKey:@"id"]objectForKey:@"text"] integerValue]]]];
    [request setDelegate:self];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"GETSERVICE" forKey:@"TYPE"]];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [SVProgressHUD dismiss];
    NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    if([[request.userInfo objectForKey:@"TYPE"] isEqualToString:@"GETSERVICE"])
    {
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

    }
    else
    {
        if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
        {
            
            if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"favourites"]objectForKey:@"favourite"] isKindOfClass:[NSArray class]])
            {
                favouritesList = [[[responseDictionary objectForKey:@"response"]objectForKey:@"favourites"]objectForKey:@"favourite"];
            }
            else
            {
                favouritesList = [NSArray arrayWithObject:[[[responseDictionary objectForKey:@"response"]objectForKey:@"favourites"]objectForKey:@"favourite"]];
            }
            NSLog(@"ARRAY %@",favouritesList);
            [SVProgressHUD dismiss];
            [favouritesTable reloadData];
        }
    }
}

@end