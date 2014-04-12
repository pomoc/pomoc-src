//
//  PMApplicationMessage.m
//  PomocCore
//
//  Created by Bang Hui Lim on 4/12/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMApplicationMessage.h"

@interface PMApplicationMessage ()

@property (nonatomic) PMApplicationMessageCode code;
@property (nonatomic) NSString *conversationId;
@property (nonatomic) NSString *referalUserId;

@end

@implementation PMApplicationMessage

+ (NSString *)stringOfMessageCode:(PMApplicationMessageCode)code
{
    switch (code) {
        case PMApplicationMessageCodeHandle:
            return @"handle";
        case PMApplicationMessageCodeUnhandle:
            return @"unhandle";
        case PMApplicationMessageCodeReferHandler:
            return @"referHandler";
    }
    return nil;
}

- (id)initWithMessageCode:(PMApplicationMessageCode)code
           conversationId:(NSString *)conversationId
{
    self = [super init];
    if (self) {
        self.code = code;
        self.conversationId = conversationId;
    }
    return self;
}

- (id)initWithMessageCode:(PMApplicationMessageCode)code
           conversationId:(NSString *)conversationId
            referalUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        self.code = code;
        self.conversationId = conversationId;
        self.referalUserId = userId;
    }
    return self;
}

- (NSDictionary *)jsonObject
{
    NSMutableDictionary *jsonData = [[super jsonObject] mutableCopy];
    
    jsonData[MESSAGE_TYPE] = [PMApplicationMessage stringOfMessageCode:self.code];
    
    if (self.conversationId) {
        jsonData[MESSAGE_CONVERSATION_ID] = self.conversationId;
    }
    
    return [NSDictionary dictionaryWithDictionary:jsonData];
}

@end