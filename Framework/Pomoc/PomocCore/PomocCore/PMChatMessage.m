//
//  PMChatMessage.m
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMChatMessage.h"

@interface PMChatMessage ()

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *conversationId;

@end

@implementation PMChatMessage

- (id)initWithMessage:(NSString *)message conversationId:(NSString *)conversationId
{
    self = [super init];
    if (self) {
        self.message = message;
        self.conversationId = conversationId;
    }
    return self;
}

- (NSDictionary *)jsonObject
{
    NSMutableDictionary *jsonData = [[super jsonObject] mutableCopy];
    jsonData[@"message"] = self.message;
    jsonData[@"conversationId"] = self.conversationId;
    
    return [NSDictionary dictionaryWithDictionary:jsonData];
}

@end
