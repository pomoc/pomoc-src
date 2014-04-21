//
//  PMStatusMessage.m
//  PomocCore
//
//  Created by soedar on 21/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMStatusMessage.h"

#define JOIN_MESSAGE    @"JOIN_MESSAGE"
#define LEAVE_MESSAGE   @"LEAVE_MESSAGE"
#define NONE_MESSAGE    @"NONE"

@implementation PMStatusMessage

+ (NSString *)stringFromCode:(PMStatusMessageCode)code
{
    switch(code) {
        case PMStatusMessageNone:
            return NONE_MESSAGE;
        case PMStatusMessageJoin:
            return JOIN_MESSAGE;
        case PMStatusMessageLeave:
            return LEAVE_MESSAGE;
    }
    return nil;
}

+ (PMStatusMessageCode)codeFromString:(NSString *)string
{
    if ([string isEqualToString:JOIN_MESSAGE]) {
        return PMStatusMessageJoin;
    }
    else if ([string isEqualToString:LEAVE_MESSAGE]) {
        return PMStatusMessageLeave;
    }
    else {
        return PMStatusMessageNone;
    }
}

- (id)initWithMessageCode:(PMStatusMessageCode)code conversationId:(NSString *)conversationId
{
    NSString *messageString = [PMStatusMessage stringFromCode:code];
    
    self = [super initWithMessage:messageString conversationId:conversationId];
    if (self) {
    }
    return self;
}

- (PMStatusMessageCode)code
{
    return [PMStatusMessage codeFromString:self.message];
}

@end
