//
//  PomocChatView+Screenshot.m
//  PomocSDK
//
//  Created by soedar on 3/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PomocChatView+Screenshot.h"

@implementation PomocChatView (Screenshot)

- (UIImage *)screenshotOfMainWindow
{
    // iOS >= 7
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIGraphicsBeginImageContext(window.bounds.size);
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
