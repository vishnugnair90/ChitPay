//
//  CPNotificationHandler.h
//  ChitPay
//
//  Created by Armia on 10/1/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RNFrostedSidebar.h"

#import "FUIAlertView.h"

#import "FlatUIKit.h"

@interface CPNotificationHandler : NSObject<RNFrostedSidebarDelegate,FUIAlertViewDelegate,UITextFieldDelegate>

+(CPNotificationHandler *)singleton;

-(void)refreshUser;
-(void)getNotificaton;
-(void)linkDevice;
-(void)delinkDevive;
-(void)crediAction:(NSDictionary *)payload;

@end
