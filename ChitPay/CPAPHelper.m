//
//  CPAPHelper.m
//  ChitPay
//
//  Created by Armia on 10/28/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import "CPAPHelper.h"

@implementation CPAPHelper
+ (CPAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static CPAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.chithub.chitpay.cp1000",@"com.chithub.chitpay.cp2000",@"com.chithub.chitpay.cp3000",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}
@end
