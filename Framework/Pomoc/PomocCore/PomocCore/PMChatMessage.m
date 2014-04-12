//
//  PMChatMessage.m
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMChatMessage.h"
#import "PMChatMessage_Private.h"
#import "PMUser.h"
#import "PMUserManager.h"

@interface PMChatMessage ()

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) PMUser *user;

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

- (id)initWithJsonData:(NSDictionary *)data
{
    self = [super initWithJsonData:data];
    if (self) {
        self.message = data[MESSAGE_MESSAGE];
        self.conversationId = data[MESSAGE_CONVERSATION_ID];
        self.userId = data[MESSAGE_USER_ID];
    }
    return self;
}

- (NSDictionary *)jsonObject
{
    NSMutableDictionary *jsonData = [[super jsonObject] mutableCopy];
    jsonData[MESSAGE_MESSAGE] = self.message;
    jsonData[MESSAGE_CONVERSATION_ID] = self.conversationId;
    
    return [NSDictionary dictionaryWithDictionary:jsonData];
}

- (void)resolveUserWithCompletion:(void (^)(PMUser *user))completion
{
    [PMUserManager getUserObjectFromUserId:self.userId completionBlock:^(PMUser *user) {
        if (completion) {
            self.user = user;
            completion(user);
        }
    }];
}

- (void)resolveUser
{
    self.user = [PMUserManager getUserObjectFromUserId:self.userId];
}

@end
