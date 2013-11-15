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
        }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                                                forKeyPath:@"notification_count"
                                                                   options:NSKeyValueObservingOptionNew
                                                                   context:NULL];
    UISwipeGestureRecognizer * Swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onBurger:)];
    Swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:Swipeleft];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"favourites.list\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
    
    [SVProgressHUD showErrorWithStatus:@"Feature not available right now"];
    //[SVProgressHUD show];
    //[request startAsynchronous];

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
    cell.textLabel.font = [UIFont fontWithName:@"LaoUI.ttf" size:20.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //NSLog(@"MENU %@",[[[menuList objectAtIndex:indexPath.row]objectForKey:@"groupname"]objectForKey:@"name"]);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg"]];
    cell.selectedBackgroundView = selectionColor;
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
    //NSArray *array = [[NSArray alloc]init];
    [SVProgressHUD show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?model=services&group_id=&service_id=%d",[defaults objectForKey:@"server"],[[[[favouritesList objectAtIndex:indexPath.row]objectForKey:@"id"]objectForKey:@"text"] integerValue]]]];
    [request setDelegate:self];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"GETSERVICE" forKey:@"TYPE"]];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [SVProgressHUD dismiss];
    NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"DATA %@",responseDictionary);
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
