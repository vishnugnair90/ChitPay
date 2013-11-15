//
//  ChitPayViewController.m
//  ChitPay
//
//  Created by Vishnu Nair on 11/15/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "ChitPayViewController.h"

#import "FlatUIKit.h"

@interface ChitPayViewController ()<FUIAlertViewDelegate>
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation ChitPayViewController
@synthesize toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBar.translucent = NO;
        UINavigationController *navController = self.navigationController;
        if ([navController.navigationBar respondsToSelector:@selector(barTintColor)]) {
            
            // we're running iOS 7
            navController.navigationBar.barTintColor = [UIColor blackColor];
            
        } else {
            
            // we're on iOS 6 and before
            navController.navigationBar.tintColor = [UIColor blackColor];
        }
        
        UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *backButtonImage4 = [UIImage imageNamed:@"Home_logo@2x.png"];
        [button5 setUserInteractionEnabled:YES];
        [button5 setBackgroundImage:backButtonImage4 forState:UIControlStateNormal];
        [button5 addTarget:self action:@selector(onBurger:) forControlEvents:UIControlEventTouchUpInside];
        button5.frame = CGRectMake(0, 0, 100, 40);
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button5];
        
        self.navigationItem.leftBarButtonItems =[NSArray arrayWithObjects:barButtonItem, nil];
        
        
        //SETTINGS BUTTON
        UIImage* image1 = [UIImage imageNamed:@"ico_settings_normal"];
        CGRect frame1 = CGRectMake(0, 0, image1.size.width, image1.size.height);
        UIButton* button1 = [[UIButton alloc] initWithFrame:frame1];
        //[button setTitle:@"Logout" forState:UIControlStateNormal & UIControlStateHighlighted];
        [button1 setImage:[UIImage imageNamed:@"ico_settings_normal"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"ico_settings_hover"] forState:UIControlStateHighlighted];
        [button1 addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
        
        //SHARE BUTTON
        UIImage* image2 = [UIImage imageNamed:@"ico_share_normal"];
        CGRect frame2 = CGRectMake(0, 0, image2.size.width, image2.size.height);
        UIButton* button2 = [[UIButton alloc] initWithFrame:frame2];
        //[button setTitle:@"Logout" forState:UIControlStateNormal & UIControlStateHighlighted];
        [button2 setImage:[UIImage imageNamed:@"ico_share_normal"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"ico_share_hover"] forState:UIControlStateHighlighted];
        [button2 addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
        
        //FAVOURITES BUTTON
        UIImage* image3 = [UIImage imageNamed:@"ico_favourites_normal"];
        CGRect frame3 = CGRectMake(0, 0, image3.size.width, image3.size.height);
        UIButton* button3 = [[UIButton alloc] initWithFrame:frame3];
        //[button setTitle:@"Logout" forState:UIControlStateNormal & UIControlStateHighlighted];
        [button3 setImage:[UIImage imageNamed:@"ico_favourites_normal"] forState:UIControlStateNormal];
        [button3 setImage:[UIImage imageNamed:@"ico_favourites_hover"] forState:UIControlStateHighlighted];
        [button3 addTarget:self action:@selector(favourites:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton3 = [[UIBarButtonItem alloc] initWithCustomView:button3];
        
        //LOGOUT BUTTON
        UIImage* image4 = [UIImage imageNamed:@"ico_logout_normal"];
        CGRect frame4 = CGRectMake(0, 0, image4.size.width, image4.size.height);
        UIButton* button4 = [[UIButton alloc] initWithFrame:frame4];
        //[button setTitle:@"Logout" forState:UIControlStateNormal & UIControlStateHighlighted];
        [button4 setImage:[UIImage imageNamed:@"ico_logout_normal"] forState:UIControlStateNormal];
        [button4 setImage:[UIImage imageNamed:@"ico_logout_hover"] forState:UIControlStateHighlighted];
        [button4 addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton4 = [[UIBarButtonItem alloc] initWithCustomView:button4];
        
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        CGRect frame, remain;
        CGRectDivide(self.view.bounds, &frame, &remain, 44, CGRectMaxYEdge);
        toolbar = [[UIToolbar alloc] initWithFrame:frame];
        [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [toolbar setBarTintColor:[UIColor clearColor]];
        [toolbar setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        //[toolbar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg"]]];
        //[toolbar setBarTintColor:[UIColor colorWithWhite:0.7 alpha:0.9]];
        
        NSMutableArray *buttons = [[NSMutableArray alloc ]initWithCapacity:4];
        
        [buttons addObject:flexible];
        [buttons addObject:barButton1];
        [buttons addObject:flexible];
        [buttons addObject:barButton2];
        [buttons addObject:flexible];
        [buttons addObject:barButton3];
        [buttons addObject:flexible];
        [buttons addObject:barButton4];
        [buttons addObject:flexible];


        
        [toolbar setItems:buttons animated:NO];
        [self.view addSubview:toolbar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden =NO;
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    callout.tintColor = [UIColor colorFromHexCode:@"2294ec"];
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
            [self.navigationController pushViewController:ProfileViewController animated:NO];
        }
            break;
        case 2:
        {
            NSLog(@"BALANCE");
            CPBalanceViewController *BalanceViewController = [[CPBalanceViewController alloc]initWithNibName:@"CPBalanceViewController" bundle:nil];
            [self.navigationController pushViewController:BalanceViewController animated:NO];
        }
            break;
        case 3:
        {
            NSLog(@"TRANSFER");
            CPTransferViewController *TransferViewController = [[CPTransferViewController alloc]initWithNibName:@"CPTransferViewController" bundle:nil];
            [self.navigationController pushViewController:TransferViewController animated:NO];
        }
            break;
        case 4:
        {
            NSLog(@"NOTIFICATIONS");
            CPNotificationListViewController *NotificationListViewController = [[CPNotificationListViewController alloc]initWithNibName:@"CPNotificationListViewController" bundle:nil];
            [self.navigationController pushViewController:NotificationListViewController animated:NO];
        }
            break;
        case 5:
        {
            NSLog(@"STATEMENT");
            CPStatementViewController *StatementViewController = [[CPStatementViewController alloc]initWithNibName:@"CPStatementViewController" bundle:nil];
            [self.navigationController pushViewController:StatementViewController animated:NO];
        }
            break;
        case 6:
        {
            NSLog(@"TRANSACTIONS");
            CPTransactionsViewController *TransactionsListViewController = [[CPTransactionsViewController alloc]initWithNibName:@"CPTransactionsViewController" bundle:nil];
            [self.navigationController pushViewController:TransactionsListViewController animated:NO];
        }
            break;
        case 7:
        {
            NSLog(@"LOGOUT");
            [[CPNotificationHandler singleton]delinkDevive];
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

-(void)settings:(id)sender
{
    [self onBurger:Nil];
}

-(void)share:(id)sender
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

-(void)favourites:(id)sender
{
    CPFavouritesViewController *FavouritesViewController = [[CPFavouritesViewController alloc]initWithNibName:@"CPFavouritesViewController" bundle:nil];
    [self.navigationController pushViewController:FavouritesViewController animated:YES];
}

-(void)logout:(id)sender
{
    [[CPNotificationHandler singleton]delinkDevive];
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
@end
