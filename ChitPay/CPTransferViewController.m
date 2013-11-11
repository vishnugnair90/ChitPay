//
//  CPTransferViewController.m
//  ChitPay
//
//  Created by Armia on 10/17/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPTransferViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface CPTransferViewController ()
{
    NSString *PIN;
}

@end

@implementation CPTransferViewController

@synthesize txtAccountNo,txtAmount,txtComment,lblName;

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillDisappearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillDisappearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];


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

-(IBAction)ProceedAction:(id)sender
{
    FUIAlertView *alertView = [[FUIAlertView alloc]initWithTitle:@"ENTER PIN" message:@"" delegate:self cancelButtonTitle:@"OKAY" otherButtonTitles:@"", nil];
    alertView.backgroundOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    alertView.defaultButtonColor = [UIColor midnightBlueColor];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonShadowColor = [UIColor clearColor];
    alertView.defaultButtonColor = [UIColor clearColor];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    [alertView.titleLabel setFont:[UIFont fontWithName:@"LaoUI" size:20.0]];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtAccountNo.layer.borderWidth = kBorderWidth;
    txtAccountNo.layer.cornerRadius = kBorderCurve;
    txtAccountNo.layer.borderColor = [[UIColor clearColor]CGColor];
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

-(IBAction)ValidateAccountAction:(id)sender
{
    NSLog(@"START VALIDATION");
    [SVProgressHUD show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.authenticate\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account_no>%@</account_no>",txtAccountNo.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"ACCOUNTAUTHENTICATION" forKey:@"TYPE"]];
    [request setPostBody:postBody];
    [SVProgressHUD show];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [SVProgressHUD dismiss];
    NSString *receivedString = [request responseString];
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
    NSLog(@"%@",responseDictionary);
    if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
    {
        if([[request.userInfo objectForKey:@"TYPE"] isEqualToString:@"ACCOUNTAUTHENTICATION"])
        {
            //[self LoadNotificationData];
            NSLog(@"DONE");
            txtAccountNo.layer.borderWidth = kBorderWidth;
            txtAccountNo.layer.cornerRadius = kBorderCurve;
            txtAccountNo.layer.borderColor = [[UIColor greenColor]CGColor];
            [lblName setText:[[[[responseDictionary objectForKey:@"response"]objectForKey:@"account"]objectForKey:@"account_name"]objectForKey:@"text"]];
            [lblName setHidden:NO];
            [txtAmount setHidden:NO];
            [txtComment setHidden:NO];

        }
        else
        {
            NSString *receivedString = [request responseString];
            NSDictionary *responseDictionary = [XMLReader dictionaryForXMLString:receivedString error:nil];
            
            if([[[[responseDictionary objectForKey:@"response"]objectForKey:@"response_code"]objectForKey:@"text"]integerValue] == 100)
            {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"AMOUNT TRANSFER SUCCESSFUL\n Balance: %@\n Transaction id: %@",[[[[responseDictionary objectForKey:@"response"]objectForKey:@"account"]objectForKey:@"balance"]objectForKey:@"text"],[[[[responseDictionary objectForKey:@"response"]objectForKey:@"account"]objectForKey:@"transaction_id"]objectForKey:@"text"]]];
                [self performSelector:@selector(delayedPop) withObject:Nil afterDelay:3.0];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"transfer failed"];
            }
        }
        
    }
    else
    {
        txtAccountNo.layer.borderWidth = kBorderWidth;
        txtAccountNo.layer.cornerRadius = kBorderCurve;
        txtAccountNo.layer.borderColor = [[UIColor redColor]CGColor];
        
        [SVProgressHUD showErrorWithStatus:@"INVALID ACCOUNT NUMBER"];
        NSLog(@"FAILED");

    }
    
}
-(void)Submit:(id)sender
{
    [SVProgressHUD show];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[defaults objectForKey:@"server"]]];
    [request setDelegate:self];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<request method=\"account.transfer\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<username>%@</username>",[defaults objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<password>%@</password>",[defaults objectForKey:@"password"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</credentials>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<sender_account_no>%@</sender_account_no>",[[[[[defaults objectForKey:@"account_details"]objectForKey:@"response"]objectForKey:@"user"]objectForKey:@"account_id"]objectForKey:@"text"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<receiver_account_no>%@</receiver_account_no>",txtAccountNo.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<amount>%@</amount>",txtAmount.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<pin>%@</pin>",PIN] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<notes>%@</notes>",txtComment.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</account>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"ACCOUNTTRANSFER" forKey:@"TYPE"]];
    [request setPostBody:postBody];
    [SVProgressHUD show];
    [request startAsynchronous];
}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 999)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [self Submit:self];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
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

- (void)handleNotification:(NSNotification *)notif
{
    NSLog(@"Notification recieved: %@", notif.name);
    NSLog(@"Status user info key: %@", [notif.userInfo objectForKey:SVProgressHUDStatusUserInfoKey]);
    NSString *str = [notif.userInfo objectForKey:SVProgressHUDStatusUserInfoKey];
    if ([str rangeOfString:@"AMOUNT TRANSFER SUCCESSFUL"].location != NSNotFound)
    {
        NSLog(@"No it does not contain that word");
    }
    else
    {
        NSLog(@"Yes it does contain that word");
    }
}

- (void)delayedPop
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end
