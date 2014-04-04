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

#import "PMCore.h"
#import "PMCore_Private.h"

@implementation PMConversation

- (void)sendTextMessage:(NSString *)message
{
    [PMCore sendTextMessage:message conversationId:self.conversationId];
}

- (NSArray *)messages
{
    return [self.allMessages copy];
}



@end
