//
//  Utility.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 25/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSString *)formatDateForTable :(NSDate *)dateToFormat
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd 'at' HH:MM"];
    NSString *dateString = [dateFormatter stringFromDate:dateToFormat];
    return dateString;
}

+ (NSDictionary *)navigationTitleDesign
{
    return @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:18.0f],
             NSForegroundColorAttributeName: [UIColor whiteColor]};
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    if(height < width)
        rect.origin.y = height / 3;
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}


@end
