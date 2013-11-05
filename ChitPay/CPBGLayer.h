//
//  CPBGLayer.h
//  ChitPay
//
//  Created by Armia on 10/31/13.
//  Copyright (c) 2013 Armia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPBGLayer : NSObject

+(CAGradientLayer*) greyGradient;
+(CAGradientLayer*) blueGradient;
+(CAGradientLayer*) colorGradient :(UIColor *)color;

@end
