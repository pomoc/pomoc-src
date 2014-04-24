//
//  PMMessage+Constructors.m
//  PomocCore
//
//  Created by soedar on 24/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMMessage+Constructors.h"

#import "PMInternalMessage.h"
#import "PMApplicationMessage.h"
#import "PMChatMessage.h"
#import "PMImageMessage.h"
#import "PMStatusMessage.h"

@implementation PMMessage (Constructors)

+ (PMInternalMessage *)internalMessageWithCode:(PMInternalMessageCode)code
{
    return [[PMInternalMessage alloc] initWithMessageCode:code];
}

+ (PMInternalMessage *)internalMessageWithCode:(PMInternalMessageCode)code
                                conversationId:(NSString *)conversationId
{
    return [[PMInternalMessage alloc] initWithMessageCode:code conversationId:conversationId];
}

+ (PMInternalMessage *)internalMessageWithCode:(PMInternalMessageCode)code
                                conversationId:(NSString *)conversationId
                                 creatorUserId:(NSString *)creatorUserId
                                    createDate:(NSDate *)createDate
{
    return [[PMInternalMessage alloc] initWithMessageCode:code conversationId:conversationId creatorUserId:creatorUserId createDate:createDate];
}

+ (PMApplicationMessage *)applicationMessageWithCode:(PMApplicationMessageCode)code
                                      conversationId:(NSString *)conversationId
{
    return [[PMApplicationMessage alloc] initWithMessageCode:code conversationId:conversationId];
}

+ (PMApplicationMessage *)applicationMessageWithCode:(PMApplicationMessageCode)code
                                      conversationId:(NSString *)conversationId
                                             appData:(NSDictionary *)appData
{
    return [[PMApplicationMessage alloc] initWithMessageCode:code conversationId:conversationId appData:appData];
}

+ (PMApplicationMessage *)applicationMessageWithCode:(PMApplicationMessageCode)code
                                      conversationId:(NSString *)converstionId
                                       refereeUserId:(NSString *)refereeUserId
{
    return [[PMApplicationMessage alloc] initWithMessageCode:code conversationId:converstionId refereeUserId:refereeUserId];
}

+ (PMChatMessage *)chatMessageWithMessage:(NSString *)message conversationId:(NSString *)conversationId
{
    return [[PMChatMessage alloc] initWithMessage:message conversationId:conversationId];
}

+ (PMChatMessage *)chatMessageFromJsonData:(NSDictionary *)dictionary
{
    if ([dictionary[MESSAGE_CLASS] isEqualToString:[[PMChatMessage class] description]]) {
        return [[PMChatMessage alloc] initWithJsonData:dictionary];
    } else if ([dictionary[MESSAGE_CLASS] isEqualToString:[[PMImageMessage class] description]]) {
        return [[PMImageMessage alloc] initWithJsonData:dictionary];
    } else if ([dictionary[MESSAGE_CLASS] isEqualToString:[[PMStatusMessage class] description]]) {
        return [[PMStatusMessage alloc] initWithJsonData:dictionary];
    }
    return nil;
}

+ (PMImageMessage *)imageMessageWithId:(NSString *)imageId conversationId:(NSString *)conversationId
{
    return [[PMImageMessage alloc] initWithImageId:imageId conversationId:conversationId];
}

+ (PMStatusMessage *)statusMessageWithCode:(PMStatusMessageCode)code conversationId:(NSString *)conversationId
{
    return [[PMStatusMessage alloc] initWithMessageCode:code conversationId:conversationId];
}

@end
