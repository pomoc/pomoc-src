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
#import "PMImageMessage.h"

@interface PMMessage ()

@property (nonatomic, strong) NSDate *timestamp;

@end

@implementation PMMessage

+ (PMInternalMessage *)internalMessageWithCode:(PMInternalMessageCode)code
{
    return [[PMInternalMessage alloc] initWithMessageCode:code];
}

+ (PMInternalMessage *)internalMessageWithCode:(PMInternalMessageCode)code
                                conversationId:(NSString *)conversationId
{
    return [[PMInternalMessage alloc] initWithMessageCode:code conversationId:conversationId];
}

+ (PMChatMessage *)chatMessageWithMessage:(NSString *)message conversationId:(NSString *)conversationId
{
    return [[PMChatMessage alloc] initWithMessage:message conversationId:conversationId];
}

+ (PMChatMessage *)chatMessageFromJsonData:(NSDictionary *)dictionary
{
    if ([dictionary[MESSAGE_CLASS] isEqualToString:[[PMChatMessage class] description]]) {
        return [[PMChatMessage alloc] initWithJsonData:dictionary];
    }
    return nil;
}

+ (PMImageMessage *)imageMessageWithUrl:(NSString *)imageUrl conversationId:(NSString *)conversationId
{
    return [[PMImageMessage alloc] initWithImageUrl:imageUrl conversationId:conversationId];
}

+ (PMImageMessage *)imageMessageFromJsonData:(NSDictionary *)dictionary
{
    if ([dictionary[MESSAGE_CLASS] isEqualToString:[[PMImageMessage class] description]]) {
        return [[PMImageMessage alloc] initWithJsonData:dictionary];
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.timestamp = [NSDate date];
    }
    return self;
}

- (id)initWithJsonData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        NSTimeInterval intervalSince1970 = [data[MESSAGE_TIMESTAMP] floatValue] / 1000;
        self.timestamp = [NSDate dateWithTimeIntervalSince1970:intervalSince1970];
    }
    return self;
}

- (NSDictionary *)jsonObject
{
    return @{MESSAGE_TIMESTAMP: @((long long)([self.timestamp timeIntervalSince1970]*1000)),
                 MESSAGE_CLASS: [[self class] description]};
}

@end
