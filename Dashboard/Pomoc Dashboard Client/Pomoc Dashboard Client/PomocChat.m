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

- (id)initWithChannel: (NSString *)channelName {
    
    if ((self = [super init])) {
        _channelName = channelName;
        _chatMessages = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
