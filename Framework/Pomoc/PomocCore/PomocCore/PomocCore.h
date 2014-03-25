//
//  PomocCore.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PomocCoreDelegate.h"

@interface PomocCore : NSObject

+ (void)initWithAppID:(NSString *)appId delegate:(id<PomocCoreDelegate>)delegate;
+ (void)startConversationWithUserId:(NSString *)userId completion:(void (^)(NSString *conversationId))completion;
+ (void)sendMessage:(NSString *)message userId:(NSString *)userId channel:(NSString *)channel;

@end
