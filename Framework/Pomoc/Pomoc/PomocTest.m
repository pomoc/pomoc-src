//
//  PomocTest.m
//  Pomoc
//
//  Created by soedar on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PomocTest.h"
#import "PM_Core.h"

@implementation PomocTest

+ (NSString *)testString
{
    PM_Core *core = [[PM_Core alloc] init];
    while (core.socket.readyState != SR_OPEN) {
        NSLog([NSString stringWithFormat:@"%d", core.socket.readyState]);
    }
    return @"Connected";
}

@end
