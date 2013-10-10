//
//  CPNotificationHandler.h
//  ChitPay
//
//  Created by Armia on 10/1/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPNotificationHandler : NSObject

+(CPNotificationHandler *)singleton;

-(void)getNotificaton;

@end
