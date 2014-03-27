//
//  PomocChat.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PomocChat.h"
#import "PomocChatMessage.h"

@implementation PomocChat

- (id)initWithConversation: (NSString *)conversationId
{
    if ((self = [super init])) {
        _conversationId = conversationId;
        _chatMessages = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
