//
//  PMMessage+Constructors.h
//  PomocCore
//
//  Created by soedar on 24/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMMessage.h"

@class PMInternalMessage, PMChatMessage, PMImageMessage, PMApplicationMessage, PMStatusMessage;

@interface PMMessage (Constructors)

+ (PMInternalMessage *)internalMessageWithCode:(PMInternalMessageCode)code;
+ (PMInternalMessage *)internalMessageWithCode:(PMInternalMessageCode)code
                                conversationId:(NSString *)conversationId;
+ (PMInternalMessage *)internalMessageWithCode:(PMInternalMessageCode)code
                                conversationId:(NSString *)conversationId
                                 creatorUserId:(NSString *)creatorUserId
                                    createDate:(NSDate *)createDate;

+ (PMApplicationMessage *)applicationMessageWithCode:(PMApplicationMessageCode)code
                                      conversationId:(NSString *)conversationId;
+ (PMApplicationMessage *)applicationMessageWithCode:(PMApplicationMessageCode)code
                                      conversationId:(NSString *)converstionId
                                       refereeUserId:(NSString *)refereeUserId;
+ (PMApplicationMessage *)applicationMessageWithCode:(PMApplicationMessageCode)code
                                      conversationId:(NSString *)conversationId
                                             appData:(NSDictionary *)appData;

+ (PMChatMessage *)chatMessageWithMessage:(NSString *)message conversationId:(NSString *)conversationId;
+ (PMImageMessage *)imageMessageWithId:(NSString *)imageId conversationId:(NSString *)conversationId;
+ (PMStatusMessage *)statusMessageWithCode:(PMStatusMessageCode)code conversationId:(NSString *)conversationId;

+ (PMChatMessage *)chatMessageFromJsonData:(NSDictionary *)data;

@end
