//
//  PomocMessage.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMInternalMessage;

typedef enum {
    PMInternalMessageCodeNone,
    PMInternalMessageCodeNewConversation,
    PMInternalMessageCodeObserveConversationList
} PMInternalMessageCode;

@interface PMMessage : NSObject

- (id)init;
- (NSDictionary *)jsonObject;

+ (PMMessage *)internalMessageWithCode:(PMInternalMessageCode)code;
+ (PMMessage *)chatMessageWithMessage:(NSString *)message conversationId:(NSString *)conversationId;

@property (nonatomic, readonly) NSDate *timestamp;

@end
