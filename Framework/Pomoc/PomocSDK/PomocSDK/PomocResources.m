//
//  PomocResources.m
//  PomocSDK
//
//  Created by soedar on 6/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PomocResources.h"

@implementation PomocResources

+ (NSBundle *)frameworkBundle
{
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"PomocSDK.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}

+ (UIImage *)imageNamed:(NSString *)imageName type:(NSString *)type
{
    NSString *imageString = [[PomocResources frameworkBundle] pathForResource:imageName ofType:type];
    return [UIImage imageWithContentsOfFile:imageString];
}

@end
