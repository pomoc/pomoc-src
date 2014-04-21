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
#import "PMImageMessage.h"
#import "PMChatMessage_Private.h"
#import "PMInternalMessage.h"
#import "PMUserManager.h"
#import "PMNote.h"

@implementation PMConversation (PMCore)

- (id)initWithConversationId:(NSString *)conversationId creatorUserId:(NSString *)creatorUserId createDate:(NSDate *)createDate
{
    self = [super init];
    if (self) {
        self.conversationId = conversationId;
        self.creator = [PMUserManager getUserObjectFromUserId:creatorUserId];
        self.createDate = createDate;
        self.allMessages = [NSMutableArray array];
    }
    return self;
}

- (void)addMessage:(PMMessage *)message
{
    [self.allMessages addObject:message];
    
    if ([message isKindOfClass:[PMChatMessage class]]) {
        PMChatMessage *chatMessage = (PMChatMessage *)message;
        [chatMessage resolveUserWithCompletion:^(PMUser *user) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateDelegateOfMessage:chatMessage];
            });
        }];
    } else {
        [self updateDelegateOfMessage:message];
    }
}

- (void)addNote:(PMNote *)note
{
    [self.allNotes addObject:note];
    [self updateDelegateOfNote:note];
}

- (void)updateDelegateOfMessage:(PMMessage *)message
{
    Class messageClass = [message class];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(conversation:didReceiveMessage:)]) {
            [self.delegate conversation:self didReceiveMessage:message];
        }

        if (messageClass == [PMChatMessage class] && [self.delegate respondsToSelector:@selector(conversation:didReceiveChatMessage:)]) {
            [self.delegate conversation:self didReceiveChatMessage:(PMChatMessage *)message];
        }
        
        if (messageClass == [PMImageMessage class] && [self.delegate respondsToSelector:@selector(conversation:didReceiveImageMessage:)]) {
            [self.delegate conversation:self didReceiveImageMessage:(PMImageMessage *)message];
        }
        
        if (messageClass == [PMInternalMessage class] && [self.delegate respondsToSelector:@selector(conversation:didReceiveInternalMessage:)]) {
            [self.delegate conversation:self didReceiveInternalMessage:(PMInternalMessage *)message];
        }
    }
}

- (void)updateDelegateOfNote:(PMNote *)note
{
    if ([self.delegate respondsToSelector:@selector(conversation:didReceiveNote:)]) {
        [self.delegate conversation:self didReceiveNote:note];
    }
}

@end
