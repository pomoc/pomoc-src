//
//  PomocMessage.m
//  ChatClient
//
//  Created by Bang Hui Lim on 3/25/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PomocMessage.h"

@implementation PomocMessage

- (id)initWithUsername:(NSString *)username withChannel:(NSString *)channel
             withType:(NSString *)type withMessage:(NSString *)message
{
    self = [super init];
    if ([MESSAGE_TYPES containsObject:type] && self) {
        _username = username;
        _channel = channel;
        _type = type;
        _message = message;
        return self;
    }
    return nil;
}

- (id)initWithJSONString:(NSString *)jsonString
{
    self = [super init];
    NSDictionary * jsonObject = [NSJSONSerialization
                                 JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                 options:NSJSONReadingMutableContainers
                                 error:nil];
    if (self && jsonObject) {
        _username = jsonObject[MSG_USERNAME];
        _channel = jsonObject[MSG_CHANNEL];
        _type = jsonObject[MSG_TYPE];
        _message = jsonObject[MSG_MESSAGE];
        return self;
    }
    return nil;
}

- (NSDictionary *)getJSONObject
{
    return @{MSG_USERNAME: _username,
             MSG_CHANNEL:_channel,
             MSG_TYPE: _type,
             MSG_MESSAGE: _message
             };
}

@end
