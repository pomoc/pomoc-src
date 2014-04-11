//
//  PMUserAgent.m
//  PomocCore
//
//  Created by Bang Hui Lim on 4/11/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMUserAgent.h"

@implementation PMUserAgent

- (id)initWithUserID:(NSString *)userId appToken:(NSString *)appToken
{
    return [super initWithUserID:userId appToken:appToken type:USER_TYPE_AGENT];
}

- (id)initWithUserID:(NSString *)userId appToken:(NSString *)appToken name:(NSString *)name
{
    return [super initWithUserID:userId appToken:appToken type:USER_TYPE_AGENT name:name ];
}

- (id)initWithJsonData:(NSDictionary *)data
{
    self = nil;
    if ([USER_TYPE_AGENT isEqualToString:self.type]) {
        self = [super initWithJsonData:data];
    }
    return self;
}

@end