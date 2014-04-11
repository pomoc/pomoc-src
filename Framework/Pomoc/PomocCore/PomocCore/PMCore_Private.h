//
//  PMCore_Private.h
//  PomocCore
//
//  Created by soedar on 4/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <PomocCore/PomocCore.h>

@interface PMCore ()

+ (void)sendTextMessage:(NSString *)message conversationId:(NSString *)conversationId;
+ (void)joinConversation:(NSString *)conversationId completion:(void (^)(NSArray *messages))completion;
+ (void)sendImageMessage:(UIImage *)image conversationId:(NSString *)conversationId;

@end
