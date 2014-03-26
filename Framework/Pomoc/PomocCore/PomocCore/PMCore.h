//
//  PomocCore.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMCoreDelegate.h"

@interface PMCore : NSObject

+ (void)initWithAppID:(NSString *)appId userId:(NSString *)userId delegate:(id<PMCoreDelegate>)delegate;
+ (void)startConversationWithCompletion:(void (^)(NSString *channelId))completion;
+ (void)sendMessage:(NSString *)message channelId:(NSString *)channelId;

@end
