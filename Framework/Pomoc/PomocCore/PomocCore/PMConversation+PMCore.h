//
//  PMConversation+PMCore.h
//  PomocCore
//
//  Created by soedar on 4/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMConversation.h"
#import "PMConversation_Private.h"

@interface PMConversation (PMCore)

- (id)initWithConversationId:(NSString *)conversationId creatorUserId:(NSString *)creatorUserId createDate:(NSDate *)createDate;
- (void)addMessage:(PMMessage *)message;

@end
