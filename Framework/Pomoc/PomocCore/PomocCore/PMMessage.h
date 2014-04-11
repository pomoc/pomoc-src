//
//  PomocMessage.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMMessageConstants.h"

@class PMInternalMessage, PMChatMessage, PMImageMessage;

@interface PMMessage : NSObject

- (id)init;
- (id)initWithJsonData:(NSDictionary *)data;

- (NSDictionary *)jsonObject;

+ (PMInternalMessage *)internalMessageWithCode:(PMInternalMessageCode)code;
+ (PMInternalMessage *)internalMessageWithCode:(PMInternalMessageCode)code
                                conversationId:(NSString *)conversationId;
+ (PMChatMessage *)chatMessageWithMessage:(NSString *)message conversationId:(NSString *)conversationId;
+ (PMImageMessage *)imageMessageWithUrl:(NSString *)imageUrl conversationId:(NSString *)conversationId;

+ (PMChatMessage *)chatMessageFromJsonData:(NSDictionary *)data;

@property (nonatomic, readonly) NSDate *timestamp;

@end
