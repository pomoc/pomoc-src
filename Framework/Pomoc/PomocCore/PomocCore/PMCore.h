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

+ (void)initWithAppID:(NSString *)appId delegate:(id<PMCoreDelegate>)delegate;
+ (void)startConversationWithUserId:(NSString *)userId completion:(void (^)(NSString *channelId))completion;
+ (void)sendMessage:(NSString *)message userId:(NSString *)userId channelId:(NSString *)channelId;

@end
