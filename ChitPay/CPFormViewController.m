//
//  CPFormViewController.m
//  ChitPay
//
//  Created by Armia on 23/09/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPFormViewController.h"

#import "FlatDatePicker.h"

#import "FlatUIKit.h"

#import "CPSettingsViewController.h"

#import "CPNotificationListViewController.h"

#import "CPFavouritesViewController.h"

#import <QuartzCore/QuartzCore.h>



@interface CPFormViewController ()<FlatDatePickerDelegate,FUIAlertViewDelegate,RNFrostedSidebarDelegate>
{
    FlatDatePicker *datePicker;
    int dateFieldTag;
    NSString *PIN;
}

#define kOFFSET_FOR_KEYBOARD 215.0

@end

@implementation CPFormViewController

@synthesize fieldsArray,mode,type,cost,service_id;

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
        [button4 setUserInteractionEnabled:NO];
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
    self.view.backgroundColor = [UIColor whiteColor];
    UISwipeGestureRecognizer * Swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onBurger:)];
    Swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:Swipeleft];
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chit.png"]];
    
    //Creating some buttons:
    
    NSLog(@"DATA COUNT %d",fieldsArray.count);
    NSLog(@"COST %@",cost);
    NSLog(@"SERvId %d",service_id);
    for(int i=0; i<fieldsArray.count; i++)
    {
        CGRect textFieldFrame = CGRectMake(20.0,(i*50) + 10, 280.0, 30.0);
        UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
        [textField setTag:100+i];
        [textField setTextColor:[UIColor blackColor]];
        [textField setFont:[UIFont systemFontOfSize:20]];
        textField.layer.borderWidth = kBorderWidth;
        textField.layer.cornerRadius = kBorderCurve;
        [textField setDelegate:self];
        NSString *str = [[[fieldsArray objectAtIndex:i] objectForKey:@"field_name"]objectForKey:@"text"];
        [textField setPlaceholder:str];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        [textField setBackgroundColor:[UIColor clearColor]];
        textField.keyboardType = UIKeyboardTypeDefault;
        if([[[[fieldsArray objectAtIndex:i] objectForKey:@"field_type"]objectForKey:@"text"] isEqualToString:@"dateTime"])
        {
            [textField setInputView:nil];
            datePicker = [[FlatDatePicker alloc]initWithParentView:self.view];
            datePicker.delegate = self;
            datePicker.title = @"Select date";
            datePicker.datePickerMode = FlatDatePickerModeDate;
            dateFieldTag = textField.tag;
            [textField setInputView:datePicker];
        }
        [self.view addSubview:textField];
    }
    
    if(((mode == 1)&&(type == 2))||((mode == 2)&&(type == 2)))
    {
        NSLog(@"CREATE FIELD");
        CGRect textFieldFrame = CGRectMake(20.0,(fieldsArray.count*50) +10, 280.0, 30.0);
        UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
        [textField setTag:100+fieldsArray.count];
        [textField setTextColor:[UIColor blackColor]];
        [textField setFont:[UIFont systemFontOfSize:20]];
        textField.layer.borderWidth = kBorderWidth;
        textField.layer.cornerRadius = kBorderCurve;
        [textField setDelegate:self];
        [textField setPlaceholder:@"Amount"];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        [textField setBackgroundColor:[UIColor clearColor]];
        textField.keyboardType = UIKeyboardTypeDefault;
        [self.view addSubview:textField];
        
        CGRect buttonFrame = CGRectMake(20.0,textFieldFrame.origin.y +50, 280.0, 30.0);
        UIButton *addFavourite = [UIButton buttonWithType:UIButtonTypeCustom];
        addFavourite.frame = buttonFrame;
        [addFavourite setTitleColor:[UIColor dullBlueColor] forState:UIControlStateNormal];
        [addFavourite setTitle:@"Add To Favourites" forState:UIControlStateNormal];
        [addFavourite addTarget:self action:@selector(addFavourite:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addFavourite];
    }
    else
    {
        NSLog(@"SERVICE CHARGE");
        CGRect labelFrame = CGRectMake(20.0,(fieldsArray.count*50) +10, 280.0, 30.0);
        UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:[UIFont boldSystemFontOfSize:20.0]];
        [label setText:[NSString stringWithFormat:@"Cost %@",cost]];
        [self.view addSubview:label];
        
        CGRect buttonFrame = CGRectMake(20.0,labelFrame.origin.y +50, 280.0, 30.0);
        UIButton *addFavourite = [UIButton buttonWithType:UIButtonTypeCustom];
        addFavourite.frame = buttonFrame;
        [addFavourite setTitleColor:[UIColor dullBlueColor] forState:UIControlStateNormal];
        [addFavourite setTitle:@"Add To Favourites" forState:UIControlStateNormal];
        [addFavourite addTarget:self action:@selector(addFavourite:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addFavourite];
    }
    
    
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
-(IBAction)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submit:(id)sender
{
    FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"TRANSACTION" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Checkout", nil];
    alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    alertView.defaultButtonColor = [UIColor dullBlueColor];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonShadowColor = [UIColor clearColor];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor redColor]];
    alertView.animationDuration = 0.15;
    alertView.tag = 111;
    [alertView show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == dateFieldTag)
    {
        NSLog(@"DATE");
        [datePicker show];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"CHANGED length = %d",textField.text.length);
    if(textField.tag == 909)
    {
        if([textField.text length]>=3)
        {
            textField.text = [textField.text stringByAppendingString:string];
            PIN = textField.text;
            [textField resignFirstResponder];
        }
    }
    return YES;
}
#pragma mark - FlatDatePicker Delegate

- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender {
    UITextField *textField = (UITextField*)[self.view viewWithTag:dateFieldTag];
    [textField endEditing:YES];
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    NSString *message = [NSString stringWithFormat:@"Did valid date : %@", value];
    
    UITextField *textField = (UITextField*)[self.view viewWithTag:dateFieldTag];
    [textField endEditing:YES];
    [textField setText:value];
}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 999)
    {
        NSLog(@"CLICKED %@",fieldsArray);
        switch (buttonIndex)
        {
            case 0:
            {
                UITextField *textField = (UITextField*)[self.view viewWithTag:100+fieldsArray.count];
                
                NSLog(@"CREATE TRANSACTION");
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSLog(@"ACCOUNT %@",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]);
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
                [request setDelegate:self];
                NSMutableData *postBody = [NSMutableData data];
                [postBody appendData:[[NSString stringWithFormat:@"<request method=\"transaction.create\">"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postBody appendData:[[NSString stringWithFormat:@"<transaction>"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"<pin>%@</pin>",PIN] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"<device>Mobile Web</device>"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"<services>"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"<service>"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"<service_id>%d</service_id>",service_id] dataUsingEncoding:NSUTF8StringEncoding]];
                if([cost isEqualToString:@"N0.00"])
                {
                    [postBody appendData:[[NSString stringWithFormat:@"<amount>%@</amount>",textField.text] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                else
                {
                    NSString *amount = [cost stringByReplacingOccurrencesOfString:@"N" withString:@""];
                    amount = [amount substringToIndex:amount.length -3];
                    amount = [amount stringByReplacingOccurrencesOfString:@"," withString:@""];
                    [postBody appendData:[[NSString stringWithFormat:@"<amount>%@</amount>",amount] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                [postBody appendData:[[NSString stringWithFormat:@"<fields>"] dataUsingEncoding:NSUTF8StringEncoding]];
                for(int i=0; i<fieldsArray.count; i++)
                {
                    [postBody appendData:[[NSString stringWithFormat:@"<field>"] dataUsingEncoding:NSUTF8StringEncoding]];
                    NSString *strFieldId = [[[fieldsArray objectAtIndex:i] objectForKey:@"field_id"]objectForKey:@"text"];
                    NSString *strFieldValue =((UITextField*)[self.view viewWithTag:100+i]).text;
                    NSString *strFieldName = [[[fieldsArray objectAtIndex:i] objectForKey:@"field_name"]objectForKey:@"text"];
                    [postBody appendData:[[NSString stringWithFormat:@"<field_id>%@</field_id>",strFieldId] dataUsingEncoding:NSUTF8StringEncoding]];
                    [postBody appendData:[[NSString stringWithFormat:@"<field_value>%@</field_value>",strFieldValue] dataUsingEncoding:NSUTF8StringEncoding]];
                    [postBody appendData:[[NSString stringWithFormat:@"<field_name>%@</field_name>",strFieldName] dataUsingEncoding:NSUTF8StringEncoding]];
                    [postBody appendData:[[NSString stringWithFormat:@"</field>"] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                [postBody appendData:[[NSString stringWithFormat:@"</fields>"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"</service>"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"</services>"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"</transaction>"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
                [request setPostBody:postBody];
                NSString* newStr = [[NSString alloc] initWithData:postBody
                                                         encoding:NSUTF8StringEncoding];
                NSLog(@"POST BODY %@",newStr);
                [SVProgressHUD show];
                request.userInfo = [NSDictionary dictionaryWithObject:@"TRANSACTION" forKey:@"TYPE"];
                [request startAsynchronous];
                
            }
                break;
            default:
                break;
        }
    }
    else if(alertView.tag == 111)
    {
        NSLog(@"CLICKED %@",fieldsArray);
        switch (buttonIndex)
        {
            case 0:
            {
                NSLog(@"CANCEL TRANSACTION");
            }
                break;
            case 1:
            {
                FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"ENTER PIN" message:@"" delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:@"", nil];
                alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
                alertView.defaultButtonColor = [UIColor midnightBlueColor];
                alertView.alertContainer.backgroundColor = [UIColor whiteColor];
                alertView.defaultButtonShadowColor = [UIColor clearColor];
                alertView.defaultButtonColor = [UIColor clearColor];
                alertView.defaultButtonTitleColor = [UIColor whiteColor];
                [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
                [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor dullBlueColor]];
                alertView.animationDuration = 0.15;
                alertView.tag = 999;
                UIButton *button = [[alertView buttons]objectAtIndex:1];
                NSLog(@"%f %f %f %f",button.frame.origin.x,button.frame.origin.y,button.frame.size.height,button.frame.size.width);
                [button setUserInteractionEnabled:FALSE];
                UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(alertView.frame.origin.x+15, alertView.frame.origin.y+58, 250, 46)];
                textField.backgroundColor = [UIColor clearColor];
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.textAlignment = NSTextAlignmentCenter;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.tag = 909;
                textField.clearsOnBeginEditing = YES;
                textField.delegate = self;
                [alertView.alertContainer addSubview:textField];
                [alertView show];
            }
                break;
            default:
                break;
        }
    }
    else if(alertView.tag == 888)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}
- (void)addFavourite:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://chitbox247.com/pos/index.php/apiv2"]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"favourites.add\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<favourites>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<service_id>%d</service_id>",service_id] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</favourites>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:postBody];
    NSString* newStr = [[NSString alloc] initWithData:postBody
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"POST BODY %@",newStr);
    [SVProgressHUD show];
    request.userInfo = [NSDictionary dictionaryWithObject:@"ADDFAVOURITE" forKey:@"TYPE"];
    [request startAsynchronous];
}

-(void)alertView:(FUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"DISMISSED");
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    if([[request.userInfo objectForKey:@"TYPE"] isEqualToString:@"ADDFAVOURITE"])
    {
        NSString *receivedString = [request responseString];
        NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
        NSLog(@"FAVOURITE RESPONSE %@",[request responseString]);
        if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
        {
            [SVProgressHUD showSuccessWithStatus:@"Added to favourites"];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"Already in favourites"];
        }
    }
    else
    {
        NSString *receivedString = [request responseString];
        NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
        
        if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
        {
            //menuListArray = [[[[responseDictionary objectForKey:@"response"]objectForKey:@"menu"]objectForKey:@"groups"]objectForKey:@"group"];
            [SVProgressHUD dismiss];
            NSLog(@"RESPONSE %@",responseDictionary);
            if([[[responseDictionary objectForKey:@"response"]objectForKey:@"transaction"]objectForKey:@"pin_details"] != NULL)
            {
                FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"TRANSACTION SUCCESS" message:[NSString stringWithFormat:@"PIN    %@\nSERIAL  %@\nBATCH   %@",[[[[[[responseDictionary objectForKey:@"response"] objectForKey:@"transaction"] objectForKey:@"pin_details"]objectForKey:@"pin"]objectForKey:@"pin_no"] objectForKey:@"text"],[[[[[[responseDictionary objectForKey:@"response"] objectForKey:@"transaction"] objectForKey:@"pin_details"]objectForKey:@"pin"]objectForKey:@"pin_serial"] objectForKey:@"text"],[[[[[[responseDictionary objectForKey:@"response"] objectForKey:@"transaction"] objectForKey:@"pin_details"]objectForKey:@"pin"]objectForKey:@"pin_batch"] objectForKey:@"text"]] delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles: nil];
                alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
                alertView.defaultButtonColor = [UIColor midnightBlueColor];
                alertView.alertContainer.backgroundColor = [UIColor whiteColor];
                alertView.defaultButtonShadowColor = [UIColor clearColor];
                alertView.defaultButtonTitleColor = [UIColor whiteColor];
                [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
                [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor greenColor]];
                alertView.animationDuration = 0.15;
                alertView.tag = 888;
                [alertView show];
            }
            else
            {
                FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"TRANSACTION SUCCESS" message:[NSString stringWithFormat:@"transaction id %@",[[[[responseDictionary objectForKey:@"response"] objectForKey:@"transaction"] objectForKey:@"transaction_id"] objectForKey:@"text"]] delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles: nil];
                alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
                alertView.defaultButtonColor = [UIColor midnightBlueColor];
                alertView.alertContainer.backgroundColor = [UIColor whiteColor];
                alertView.defaultButtonShadowColor = [UIColor clearColor];
                alertView.defaultButtonTitleColor = [UIColor whiteColor];
                [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
                [[[alertView buttons]objectAtIndex:0] setButtonColor:[UIColor greenColor]];
                alertView.animationDuration = 0.15;
                alertView.tag = 888;
                [alertView show];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            NSLog(@"RESPONSE %@",responseDictionary);
            FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"TRANSACTION FAILED" message:[NSString stringWithFormat:@"%@",[[[[responseDictionary objectForKey:@"response"] objectForKey:@"transaction"] objectForKey:@"transaction_id"] objectForKey:@"text"]] delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles: nil];
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

    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"Network error"];
    
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
            [self.navigationController popToRootViewControllerAnimated:NO];
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
