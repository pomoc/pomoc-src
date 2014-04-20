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
@property (nonatomic) NSString *refereeUserId;
@property (nonatomic) NSDictionary *appData;

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
        case PMApplicationMessageCodeGetHandlers:
            return @"getHandlers";
        case PMApplicationMessageCodeAddNote:
            return @"addNotes";
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
            refereeUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        self.code = code;
        self.conversationId = conversationId;
        self.refereeUserId = userId;
    }
    return self;
}

- (id)initWithMessageCode:(PMApplicationMessageCode)code conversationId:(NSString *)conversationId appData:(NSDictionary *)appData
{
    self = [self initWithMessageCode:code conversationId:conversationId];
    if (self) {
        self.appData = appData;
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
    if (self.refereeUserId) {
        jsonData[MESSAGE_REFEREE_USERID] = self.refereeUserId;
    }
    
    if (self.appData) {
        jsonData[MESSAGE_APP_DATA] = self.appData;
    }
    
    return [NSDictionary dictionaryWithDictionary:jsonData];
}

@end