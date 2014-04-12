//
//  Utility.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 25/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSDictionary *)navigationTitleDesign;

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

+ (NSString *)formatDateForTable :(NSDate *)dateToFormat;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
