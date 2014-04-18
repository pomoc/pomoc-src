//
//  PMConversation.m
//  PomocCore
//
//  Created by soedar on 4/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMConversation.h"
#import "PMConversation_Private.h"
#import "PMConversation+PMCore.h"
#import "PMChatMessage_Private.h"

#import "PMCore.h"
#import "PMCore_Private.h"

@implementation PMConversation

- (void)joinConversationWithCompletion:(void (^)(BOOL))completion
{
    [PMCore joinConversation:self.conversationId
               creatorUserId:self.creator.userId
                  createDate:self.createDate
                  completion:^(NSArray *messages) {
        if (messages.count == 0) {
            completion(YES);
            return;
        }
        
        [self resolveUserInMessages:messages completion:^(NSArray *messages) {
            self.allMessages = [messages mutableCopy];
            if (completion) {
                completion(YES);
            }
        }];
    }];
}

- (void)sendTextMessage:(NSString *)message
{
    [PMCore sendTextMessage:message conversationId:self.conversationId];
}

- (void)sendImageMessage:(UIImage *)image
{
    [PMCore sendImageMessage:image conversationId:self.conversationId];
}

- (NSArray *)messages
{
    return [self.allMessages copy];
}

- (void)resolveUserInMessages:(NSArray *)messages completion:(void(^)(NSArray *messages))completion
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    for (PMMessage *message in messages) {
        if ([message isKindOfClass:[PMChatMessage class]]) {
            PMChatMessage *chatMessage = (PMChatMessage *)message;
            dispatch_group_async(group, queue, ^{
                [chatMessage resolveUser];
            });
        }
    }
    
    dispatch_group_notify(group, queue, ^{
        if (completion) {
            completion(messages);
        }
    });
}

@end
