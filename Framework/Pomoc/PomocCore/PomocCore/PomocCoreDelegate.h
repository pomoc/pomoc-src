//
//  PomocCoreDelegate.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PomocMessage;

@protocol PomocCoreDelegate <NSObject>

- (void)didReceiveMessage:(PomocMessage *)pomocMessage channel:(NSString *)channel;

@end
