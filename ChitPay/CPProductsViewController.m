//
//  CPProductsViewController.m
//  ChitPay
//
//  Created by Armia on 17/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPProductsViewController.h"

#import "CPFormViewController.h"

@interface CPProductsViewController ()

@end

@implementation CPProductsViewController

@synthesize menuList;

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
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chit.png"]];
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



@end

