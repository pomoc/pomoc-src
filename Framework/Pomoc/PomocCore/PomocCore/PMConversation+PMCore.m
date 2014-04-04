//
//  PMConversation+PMCore.m
//  PomocCore
//
//  Created by soedar on 4/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMConversation+PMCore.h"
#import "PMConversation_Private.h"
#import "PMMessage.h"
#import "PMChatMessage.h"
#import "PMInternalMessage.h"

@implementation PMConversation (PMCore)

- (id)initWithConversationId:(NSString *)conversationId
{
    self = [super init];
    if (self) {
        self.conversationId = conversationId;
    }
    return self;
}

- (void)addMessage:(PMMessage *)message
{
    [self.allMessages addObject:message];
    
    Class messageClass = [message class];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(conversation:didReceiveMessage:)]) {
            [self.delegate conversation:self didReceiveMessage:message];
        }
        
        if (messageClass == [PMChatMessage class] && [self.delegate respondsToSelector:@selector(conversation:didReceiveChatMessage:)]) {
            [self.delegate conversation:self didReceiveChatMessage:(PMChatMessage *)message];
        }
        
        if (messageClass == [PMInternalMessage class] && [self.delegate respondsToSelector:@selector(conversation:didReceiveInternalMessage:)]) {
            [self.delegate conversation:self didReceiveInternalMessage:(PMInternalMessage *)message];
        }
    }
}

@end
