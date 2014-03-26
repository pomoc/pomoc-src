//
//  PomocMessage.m
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMMessage.h"
#import "PMInternalMessage.h"
#import "PMChatMessage.h"

#define MESSAGE_TIMESTAMP   @"timestamp"
#define MESSAGE_CLASS       @"class"

@interface PMMessage ()

@property (nonatomic, strong) NSDate *timestamp;

@end

@implementation PMMessage

+ (PMMessage *)internalMessageWithCode:(PMInternalMessageCode)code
{
    return [[PMInternalMessage alloc] initWithMessageCode:code];
}

+ (PMMessage *)chatMessageWithMessage:(NSString *)message conversationId:(NSString *)conversationId
{
    return [[PMChatMessage alloc] initWithMessage:message conversationId:conversationId];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.timestamp = [NSDate date];
    }
    return self;
}

- (NSDictionary *)jsonObject
{
    return @{MESSAGE_TIMESTAMP: @((long long)([self.timestamp timeIntervalSince1970]*1000)),
                 MESSAGE_CLASS: [[self class] description]};
}

@end
