//
//  PMInternalMessage.m
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMInternalMessage.h"

@interface PMInternalMessage ()

@property (nonatomic) PMInternalMessageCode code;

@end

@implementation PMInternalMessage

+ (NSString *)stringOfMessageCode:(PMInternalMessageCode)code
{
    switch (code) {
        case PMInternalMessageCodeNone:
            return @"none";
        case PMInternalMessageCodeNewConversation:
            return @"newConversation";
        case PMInternalMessageCodeObserveConversationList:
            return @"observeConversationList";
    }
    return nil;
}

- (id)initWithMessageCode:(PMInternalMessageCode)code
{
    self = [super init];
    if (self) {
        self.code = code;
    }
    return self;
}

- (NSDictionary *)jsonObject
{
    NSMutableDictionary *jsonData = [[super jsonObject] mutableCopy];
    
    jsonData[MESSAGE_TYPE] = [PMInternalMessage stringOfMessageCode:self.code];
    
    return [NSDictionary dictionaryWithDictionary:jsonData];
}

@end
