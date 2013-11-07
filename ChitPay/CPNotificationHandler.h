//
//  CPNotificationHandler.h
//  ChitPay
//
//  Created by Armia on 10/1/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RNFrostedSidebar.h"


@interface CPNotificationHandler : NSObject<RNFrostedSidebarDelegate>

+(CPNotificationHandler *)singleton;

-(void)getNotificaton;
-(void)linkDevice;
-(void)delinkDevive;
-(void)showMenu;

@end
